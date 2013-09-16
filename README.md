Evopop
------------------------

This is a library for implementing simple genetic algorithms to evolve over a fitness function.


``` ruby

require 'evopop'

# Initialize the population to be trained.
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

# Train the population.
def drive(population)
  (0...population.max_generations).each do |i|
    population.train
    population.crossover
    if i != population.max_generations - 1
      population.mutate
    end
  end

  population
end

drive population

# Sort and print out candidate with highest fitness in the last generation.
candidates = population.candidates.sort_by {|c| c.fitness}
print candidates[0].dna

```