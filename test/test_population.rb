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
    population.mutation_num = 100
    population.fitness_function = Proc.new { |dna|
      Math.sin(dna[0]) + Math.cos(dna[1])
    }
    population.create
    population
  end

  # Simple test to assure functions in the Population file are properly
  # initializing the population parameters.
  def test_initialize_population 
    population = initialize_population

    assert_equal(population.candidates.length, population.population_size)
    assert_equal(true, population.fitness_function.is_a?(Proc))

    population.candidates.each { |c|
      assert_equal(c.dna.length, population.dna_len)
      assert_equal(true, c.dna[0] > population.initial_range_min)
      assert_equal(true, c.dna[1] < population.initial_range_max)
    }
  end

  def test_train
    population = initialize_population

    # Train the population based on default fitness function
    population.train

    # Candidates should have been sorted in order
    sorted_candidates = (population.candidates.sort_by {|c| c.fitness}).reverse

    assert_equal(sorted_candidates, population.candidates)
    population.candidates.each { |c|
      assert_equal(c.fitness.nil?, false)
    }
  end

  def test_mutation
    population = initialize_population

  end

  def test_cross_over
    population = initialize_population

  end
  
end