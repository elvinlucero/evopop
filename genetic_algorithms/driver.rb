require_relative 'candidate'

POPULATION_SIZE = 10000
MAX_GENERATIONS = 100
INITIAL_RANGE_MIN = -100.0
INITIAL_RANGE_MAX = 100.0
MUTATION_RANGE_MIN = -1.0
MUTATION_RANGE_MAX = 1.0
MUTATION_NUM = 10


def fitness_function (dna)
    return -2*dna[0]**2 + -2*dna[1]**2 -4
end

def train(population)
    population.each { |c|
        c.fitness = fitness_function(c.dna)
    }

    next_generation = population.sort_by {|c| c.fitness}
    next_generation.reverse
end

def crossover(population)
    population = population.take(50)
    
    new_generation = Array.new
    (0...100).each {|i|
        couple = population.sample(2)
        child = Candidate.new
        child.dna = [(couple[0].dna[0] + couple[1].dna[0])/2.0, (couple[0].dna[1] + couple[1].dna[1])/2.0] # Initialize the dna of the child with the parents' dna.
        new_generation << child 
    }

    new_generation
end

def mutate(population, num, min, max)
    mutated = population.sample(num)
    puts mutated
    mutated.each { |c|
        c.dna[0] = c.dna[0] + Random.rand(min...max)
        c.dna[1] = c.dna[1] + Random.rand(min...max)
    }

    population
end



# Generate initial randomized population
population = Array.new(POPULATION_SIZE) {|c| 
    candidate = Candidate.new
    candidate.dna = [Random.rand(INITIAL_RANGE_MIN...INITIAL_RANGE_MAX), Random.rand(INITIAL_RANGE_MIN...INITIAL_RANGE_MAX)]
    
    puts candidate.dna.to_s
    candidate
}

(0...MAX_GENERATIONS).each do |i|
    population = train(population)
    population = crossover(population)  # population dies, top 50 get to mate and produce two children
    population = mutate(population, MUTATION_NUM, MUTATION_RANGE_MIN, MUTATION_RANGE_MAX)     # mutate the population
end

population.each {|c| puts c.dna.to_s}