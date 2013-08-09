require_relative 'candidate'
require_relative 'population'

POPULATION_SIZE = 10000
DNA_LEN = 2
MAX_GENERATIONS = 100
INITIAL_RANGE_MIN = -10000.0
INITIAL_RANGE_MAX = 10000.0
MUTATION_RANGE_MIN = -100.0
MUTATION_RANGE_MAX = 100.0
MUTATION_NUM = 20
FITNESS_FUNCTION = Proc.new { |dna|
    Math.sin(dna[0]) + Math.cos(dna[1])
}

population = Population.new
population.population_size = POPULATION_SIZE
population.dna_len = DNA_LEN
population.max_generations = MAX_GENERATIONS
population.initial_range_min = INITIAL_RANGE_MIN
population.initial_range_max = INITIAL_RANGE_MAX
population.mutation_range_min = MUTATION_RANGE_MIN
population.mutation_range_max = MUTATION_RANGE_MAX
population.mutation_num = MUTATION_NUM
population.fitness_function = FITNESS_FUNCTION
population.create

(0...MAX_GENERATIONS).each do |i|
    print "Generation " << i.to_s << ": "

    population.train
    population.crossover
    if i != MAX_GENERATIONS - 1
        population.mutate
    end
end
