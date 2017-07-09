# frozen_string_literal: true

require 'spec_helper'

describe Evopop::Population do
  describe '.crossover :one_point' do
    before(:all) do
      @population = Evopop::Population.new
      @population.create
      @initial_population_size = @population.candidates.size
      5.times do
        @population.train
        @population.crossover
      end
    end

    it 'improves fitness over the generations' do
      first_averagea_fitness = @population.average_fitness.first
      last_averge_fitness = @population.average_fitness.last
      expect(first_averagea_fitness).to be < last_averge_fitness
    end

    it 'retains the same population size' do
      expect(@initial_population_size).to be == @population.candidates.size
    end
  end

  describe '.crossover :two_point' do
    before(:all) do
      # Arrange: Initialize the population with parameters for the crossover function
      @population = Evopop::Population.new
      @population.create
      @initial_population_size = @population.candidates.size

      @population.dna_len = 8
      @population.crossover_params = { ordinals: '2,4' }
      @population.crossover_function = Evopop::Crossover.method(:two_point)
      @population.create

      # Act: Train and crossover the population a number of times.
      100.times do
        @population.train
        @population.crossover
      end
    end

    it 'improves fitness over the generations' do
      first_averagea_fitness = @population.average_fitness.first
      last_averge_fitness = @population.average_fitness.last
      expect(first_averagea_fitness).to be < last_averge_fitness
    end

    it 'retains the same population size' do
      expect(@initial_population_size).to be == @population.candidates.size
    end
  end

  describe '.crossover :n_point' do
    before(:all) do
      # Arrange: Initialize the population with parameters for the crossover function
      @population = Evopop::Population.new
      @population.create
      @initial_population_size = @population.candidates.size
      @population.dna_len = 5
      @population.crossover_params = { ordinals: '0,2,3' }
      @population.crossover_function = Evopop::Crossover.method(:n_point)
      @population.population_size = 100
      @population.candidates = [
        Evopop::Candidate.new([0, 1, 2, 3, 5]),
        Evopop::Candidate.new([4, 2, 3, 8, 7]),
        Evopop::Candidate.new([4, 5, 6, 9, 0]),
        Evopop::Candidate.new([6, 5, 7, 2, 8])
      ]

      100.times do
        @population.train
        @population.crossover
      end
    end

    it 'improves fitness over the generations' do
      first_averagea_fitness = @population.average_fitness.first
      last_averge_fitness = @population.average_fitness.last
      expect(first_averagea_fitness).to be < last_averge_fitness
    end

    it 'retains the same population size' do
      expect(@initial_population_size).to be == @population.candidates.size
    end
  end

  describe '.crossover :average' do
    before(:all) do
      # Arrange: Initialize the population with parameters for the crossover function
      @population = Evopop::Population.new
      @population.create
      @initial_population_size = @population.candidates.size
      @population.crossover_function = Evopop::Crossover.method(:average)

      100.times do
        @population.train
        @population.crossover
      end
    end

    it 'improves fitness over the generations' do
      first_averagea_fitness = @population.average_fitness.first
      last_averge_fitness = @population.average_fitness.last
      expect(first_averagea_fitness).to be < last_averge_fitness
    end

    it 'retains the same population size' do
      expect(@initial_population_size).to be == @population.candidates.size
    end
  end
end
