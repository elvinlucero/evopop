# frozen_string_literal: true

require 'test/unit'
require 'evopop'

# Tests the population class with various operations.
class Evopop::PopulationTest < Test::Unit::TestCase
  attr_accessor :population

  def initialize_population
    Evopop.config.population_size = 100
    Evopop.config.dna_len = 2
    Evopop.config.max_generations = 1000
    Evopop.config.initial_range_min = -10_000.0
    Evopop.config.initial_range_max = 10_000.0
    Evopop.config.mutation_range_min = -100.0
    Evopop.config.mutation_range_max = 100.0
    Evopop.config.mutation_num = 10
    Evopop.config.crossover_params = { ordinal: (Evopop.config.dna_len / 2) }
    Evopop.config.crossover_function = Evopop::Crossover.method(:one_point)
    Evopop.config.fitness_function = proc { |dna|
      Math.sin(dna[0]) + Math.cos(dna[1])
    }

    population = Evopop::Population.new
    population.create
    population
  end

  # Simple
  def test_one_point_crossover
    # Arrange: Initialize the population
    population = initialize_population
    initial_population_size = population.candidates.size
    # Act: Train and corssover the population a number of times
    5.times do
      population.train
      population.crossover
    end

    # Assert: The initial average fitness is less than what occurs after 100 generations.
    # This is to ensure that over generations the average fitness does indeed go up, given
    # no mutation.
    first_averagea_fitness = population.average_fitness[0]
    last_averge_fitness = population.average_fitness[population.average_fitness.length - 1]
    assert_equal(true, first_averagea_fitness < last_averge_fitness)
    assert_equal(initial_population_size, population.candidates.size)
  end

  def test_two_point_crossover
    # Arrange: Initialize the population with parameters for the crossover function
    population = initialize_population
    initial_population_size = population.candidates.size
    population.dna_len = 8
    population.crossover_params = { ordinals: '2,4' }
    population.crossover_function = Evopop::Crossover.method(:two_point)
    population.create

    # Act: Train and crossover the population a number of times.
    100.times do
      population.train
      population.crossover
    end

    # Assert: The initial average fitness is less than what occurs after 100 generations.
    # This is to ensure that over generations the average fitness does indeed go up, given
    # no mutation.
    first_averagea_fitness = population.average_fitness[0]
    last_averge_fitness = population.average_fitness[population.average_fitness.length - 1]
    assert_equal(true, first_averagea_fitness < last_averge_fitness)
    assert_equal(initial_population_size, population.candidates.size)
  end

  def test_n_point_crossover
    # Arrange: Initialize the population with parameters for the crossover function
    population = initialize_population
    population.dna_len = 5
    population.crossover_params = { ordinals: '0,2,3' }
    population.crossover_function = Evopop::Crossover.method(:n_point)
    population.population_size = 100
    population.create
    population.candidates = [
      Evopop::Candidate.new([0, 1, 2, 3, 5]),
      Evopop::Candidate.new([4, 2, 3, 8, 7]),
      Evopop::Candidate.new([4, 5, 6, 9, 0]),
      Evopop::Candidate.new([6, 5, 7, 2, 8])
    ]

    # Act: Train and crossover the population a number of times.
    100.times do
      population.train
      population.crossover
    end

    # Assert: The initial average fitness is less than what occurs after 100 generations.
    # This is to ensure that over generations the average fitness does indeed go up, given
    # no mutation.
    first_averagea_fitness = population.average_fitness[0]
    last_averge_fitness = population.average_fitness[population.average_fitness.length - 1]
    assert_equal(true, first_averagea_fitness < last_averge_fitness)
  end

  def test_average_crossover
    # Arrange: Initialize the population
    population = initialize_population
    population.crossover_function = Evopop::Crossover.method(:average)

    # Act: Train and crossover the population a number of times
    100.times do
      population.train
      population.crossover
    end

    # Assert: The initial average fitness is less than what occurs after 100 generations.
    # This is to ensure that over generations the average fitness does indeed go up, given
    # no mutation.
    first_averagea_fitness = population.average_fitness[0]
    last_averge_fitness = population.average_fitness[population.average_fitness.length - 1]
    assert_equal(true, first_averagea_fitness < last_averge_fitness)
  end
end
