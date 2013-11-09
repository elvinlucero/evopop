require 'test/unit'
require 'evopop'

class PopulationTest < Test::Unit::TestCase
  attr_accessor :population

  def initialize_population
    population = Population.new
    population.population_size = 100
    population.dna_len = 2
    population.max_generations = 10000
    population.initial_range_min = -10000.0
    population.initial_range_max = 10000.0
    population.mutation_range_min = -100.0
    population.mutation_range_max = 100.0
    population.mutation_num = 10
    population.crossover_params = {:ordinal => (population.dna_len/2)}
    population.crossover_function = Crossover.method(:one_point)
    population.fitness_function = Proc.new { |dna|
      Math.sin(dna[0]) + Math.cos(dna[1])
    }
    population.create
    population
  end

  # Simple test to assure functions in the Population file are properly
  # initializing the population parameters.
  def test_initialize_population 
    # Arrange and Act: Initialize the population
    population = initialize_population

    # Assert: Check that the given properties are initialized correctly.
    assert_equal(population.candidates.length, population.population_size)
    assert_equal(true, population.fitness_function.is_a?(Proc))

    population.candidates.each { |c|
      assert_equal(c.dna.length, population.dna_len)
      assert_equal(true, c.dna[0] > population.initial_range_min)
      assert_equal(true, c.dna[1] < population.initial_range_max)
    }
  end

  # Simple test of the training function. Ensure that when training
  # finishes the fitness of the ith element of the population is 
  # less than or equal to the i-1th element of the population. I.e.
  # fitness is becoming greater over the iteration of the popoulation.
  def test_train
    # Arrange: Initialize the population
    population = initialize_population

    # Act: Train the population based on default fitness function
    population.train

    # Assert: Training has sorted the population by fitness properly
    population.candidates.length.times { |count|
      assert_equal(population.candidates[count].fitness.nil?, false)
      
      if count > 0
        assert_equal(true, population.candidates[count].fitness <= population.candidates[count-1].fitness)
      end
    }
  end

  # Simple test to ensure that only the exact number of candidates in the
  # population are mutated.
  def test_mutation
    # Arrange: Initialize the population
    population = initialize_population
    old_candidates = Marshal.load(Marshal.dump(population.candidates))

    # Act: Train the population based on default fitness function
    population.mutate

    # Assert: Only the specified number of candidates are being mutated
    counter = 0
    old_candidates.zip(population.candidates).each {|old_candidate, new_candidate|
      if old_candidate.dna.to_s != new_candidate.dna.to_s
        assert_equal(true, (old_candidate.dna[0] - new_candidate.dna[0]).abs <= population.mutation_range_max)
        assert_equal(true, (old_candidate.dna[1] - new_candidate.dna[1]).abs <= population.mutation_range_max)
        counter = counter + 1
      end
    }

    assert_equal(population.mutation_num, counter)
  end

  # Simple
  def test_one_point_crossover
    # Arrange: Initialize the population
    population = initialize_population
    
    # Act: Train and corssover the population a number of times
    5.times {
      population.train
      population.crossover
    }

    # Assert: The initial average fitness is less than what occurs after 100 generations.
    # This is to ensure that over generations the average fitness does indeed go up, given
    # no mutation.
    assert_equal(true, population.average_fitness[0] < population.average_fitness[population.average_fitness.length-1])
  end
  
  def test_two_point_crossover
    population = Population.new
    population.population_size = 100
    population.dna_len = 8
    population.max_generations = 10000
    population.initial_range_min = -10000.0
    population.initial_range_max = 10000.0
    population.mutation_range_min = -100.0
    population.mutation_range_max = 100.0
    population.mutation_num = 10
    population.crossover_params = {:ordinals => "2,4"}
    population.crossover_function = Crossover.method(:two_point)
    population.fitness_function = Proc.new { |dna|
      Math.sin(dna[0]) + Math.cos(dna[1])
    }
    population.create

    100.times {
      population.train
      population.crossover
    }

    assert_equal(true, population.average_fitness[0] < population.average_fitness[population.average_fitness.length-1])
  end

  def test_average_crossover
    # Arrange: Initialize the population
    population = initialize_population
    population.crossover_function = Crossover.method(:average)

    # Act: Train and corssover the population a number of times
    100.times {
      population.train
      population.crossover
    }

    # Assert: The initial average fitness is less than what occurs after 100 generations.
    # This is to ensure that over generations the average fitness does indeed go up, given
    # no mutation.
    assert_equal(true, population.average_fitness[0] < population.average_fitness[population.average_fitness.length-1])
  end
end