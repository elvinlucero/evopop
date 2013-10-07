require 'evopop'

# Define parameters and the fitness function.
POPULATION_SIZE = 1000
DNA_LEN = 2
MAX_GENERATIONS = 10000
INITIAL_RANGE_MIN = -10000.0
INITIAL_RANGE_MAX = 10000.0
MUTATION_RANGE_MIN = -10.0
MUTATION_RANGE_MAX = 10.0
MUTATION_NUM = 10
CROSSOVER_PARAMS = {:ordinal => (DNA_LEN/2)}
CROSSOVER_FUNCTION = Crossover.method(:one_point)
FITNESS_FUNCTION = Proc.new { |dna|
  Math.sin(dna[0]) + Math.cos(dna[1])
}


# Initialize the population to be trained.
population = Population.new
population.population_size = POPULATION_SIZE
population.dna_len = DNA_LEN
population.max_generations = MAX_GENERATIONS
population.initial_range_min = INITIAL_RANGE_MIN
population.initial_range_max = INITIAL_RANGE_MAX
population.mutation_range_min = MUTATION_RANGE_MIN
population.mutation_range_max = MUTATION_RANGE_MAX
population.mutation_num = MUTATION_NUM
population.crossover_params = CROSSOVER_PARAMS
population.crossover_function = CROSSOVER_FUNCTION
population.fitness_function = FITNESS_FUNCTION
population.create

# Primary driver, trains over a number of generations and performs crossover
# and mutation 

# Public: Train a population over a number of generations
#
# population - The population to be trained. Initializ first.
#
#
# Returns a trained population over a number of generations.
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
population.train
puts "Finished #{MAX_GENERATIONS} generations with the fittest candidate with a dna of #{population.candidates[0].dna} and a fitness of #{population.candidates[0].fitness}."
