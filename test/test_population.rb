require 'test/unit'
require 'evopop'

class PopulationTest < Test::Unit::TestCase
  def test_initialize
    population = Population.new
    population.population_size = 1000
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

    assert_equal(population.candidates.length, population.population_size)

    population.candidates.each { |c|
      assert_equal(c.dna.length, population.dna_len)
      assert_equal(true, c.dna[0] > population.initial_range_min)
      assert_equal(true, c.dna[1] < population.initial_range_max)
    }

  end
end