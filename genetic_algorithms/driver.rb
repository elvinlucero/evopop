require_relative 'candidate'

POPULATION_SIZE = 10000
MAX_GENERATIONS = 100
INITIAL_RANGE_MIN = -100.0
INITIAL_RANGE_MAX = 100.0
MUTATION_RANGE_MIN = -1.0
MUTATION_RANGE_MAX = 1.0
MUTATION_NUM = 10

class Population
    attr_accessor :candidates

    def initialize
        # Generate initial randomized population
        @candidates = Array.new(POPULATION_SIZE) {|c| 
            candidate = Candidate.new
            candidate.dna = [Random.rand(INITIAL_RANGE_MIN...INITIAL_RANGE_MAX), Random.rand(INITIAL_RANGE_MIN...INITIAL_RANGE_MAX)]
            candidate
        }
    end

    def fitness_function (dna)
        return -2*dna[0]**2 + -2*dna[1]**2 -4
    end

    def train
        @candidates.each { |c|
            c.fitness = fitness_function(c.dna)
        }

        @candidates = @candidates.sort_by {|c| c.fitness}
        @candidates = @candidates.reverse
    end

    def crossover
        @candidates = @candidates.take(50)
        
        new_generation = Array.new
        (0...100).each {|i|
            couple = @candidates.sample(2)
            child = Candidate.new
            child.dna = [(couple[0].dna[0] + couple[1].dna[0])/2.0, (couple[0].dna[1] + couple[1].dna[1])/2.0] # Initialize the dna of the child with the parents' dna.
            new_generation << child 
        }

        @candidates = new_generation
    end


    def mutate
        mutated = @candidates.sample(MUTATION_NUM)

        mutated.each { |c|
            c.dna[0] = c.dna[0] + Random.rand(MUTATION_RANGE_MIN...MUTATION_RANGE_MAX)
            c.dna[1] = c.dna[1] + Random.rand(MUTATION_RANGE_MIN...MUTATION_RANGE_MAX)
        }
    end

end



population = Population.new

(0...MAX_GENERATIONS).each do |i|
    population.train
    population.crossover  # population dies, top 50 get to mate and produce two children
    if i != MAX_GENERATIONS - 1
        population.mutate
    end
end

population.candidates.each {|c| puts c.dna.to_s}