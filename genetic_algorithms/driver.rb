require_relative 'candidate'
require_relative 'population'

POPULATION_SIZE = 10000
MAX_GENERATIONS = 100
INITIAL_RANGE_MIN = -100.0
INITIAL_RANGE_MAX = 100.0
MUTATION_RANGE_MIN = -0.5
MUTATION_RANGE_MAX = 0.5
MUTATION_NUM = 10

population = Population.new
population.population_size = POPULATION_SIZE
population.max_generations = MAX_GENERATIONS
population.initial_range_min = INITIAL_RANGE_MIN
population.initial_range_max = INITIAL_RANGE_MAX
population.mutation_range_min = MUTATION_RANGE_MIN
population.mutation_range_max = MUTATION_RANGE_MAX
population.mutation_num = MUTATION_NUM
population.create

(0...MAX_GENERATIONS).each do |i|
    population.train
    population.crossover
    if i != MAX_GENERATIONS - 1
        population.mutate
    end
end

population.candidates.each {|c| puts c.dna.to_s}