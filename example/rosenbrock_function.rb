# frozen_string_literal: true

require 'evopop'

# Initialize the population to be trained with good defaults.
population                    = Evopop::Population.new
population.population_size    = 1000
population.dna_len            = 2
population.max_generations    = 10000
population.initial_range_min  = -1000.0
population.initial_range_max  = 1000.0
population.mutation_range_min = -50.0
population.mutation_range_max = 50.0
population.mutation_num       = population.population_size * 0.20
population.crossover_params   = { ordinal: (population.dna_len / 2) }.freeze
population.crossover_function = Evopop::Crossover.method(:one_point)
population.fitness_preference = :minimum
population.fitness_function   = proc do |dna|
  a = 1
  b = 100
  x = dna[0]
  y = dna[1]

  (a - x)**2 + b * (y - x**2)**2
end

# Initialize the population
population.create

# Train a population for population.max_generations.
(0...population.max_generations).each do |i|
  population.train
  puts "At generation: #{i} at #{population.candidates[0].dna} with top fitness #{population.candidates[0].fitness}; midfitness: #{population.candidates[population.population_size/2].fitness}; bottom fitness #{population.candidates.last.fitness}"
  population.crossover
  population.mutate if i != population.max_generations - 1
end

# Sort and print out candidate with highest fitness in the last generation.
population.train
puts <<~DEBUG
  Finished #{population.max_generations} generations
  with the fittest candidate with a dna of #{population.candidates[0].dna}
  and a fitness of #{population.candidates[0].fitness}.
DEBUG
