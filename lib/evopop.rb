# frozen_string_literal: true

require 'evopop/population'
require 'evopop/candidate'
require 'evopop/crossover'
require 'evopop/crossover_array'
require 'evopop/dna'

# Toplevel class for evopop project
module Evopop
  class << self
    attr_accessor :config
  end

  def self.popconfig
    @config ||= PopulationConfig.new
    yield @config
  end

  # Defines the configuration to be available to all of Evopop
  class PopulationConfig
    attr_accessor :average_fitness, :population_size, :max_generations,
                  :initial_range_min, :initial_range_max, :mutation_range_min,
                  :mutation_range_max, :mutation_num, :dna_len,
                  :crossover_params, :crossover_function, :fitness_function

    def initialize
      @average_fitness    = []
      @population_size    = 500
      @max_generations    = 100
      @initial_range_min  = -100
      @initial_range_max  = 100
      @mutation_range_min = -10
      @mutation_range_max = 10
      @mutation_num       = (0.10 * @population_size).to_i
      @dna_len            = 1
      @crossover_params   = { ordinal: (@dna_len / 2) }
      @fitness_preference = :maximum
      @crossover_function = Evopop::Crossover.method(:one_point)
      @fitness_function   = proc do |dna|
        Math.sin(dna[0])
      end
    end
  end
end

Evopop.popconfig do |config|
  # Configure evopop here.
end
