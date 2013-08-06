class Population
    attr_accessor :candidates, :population_size, :max_generations, :initial_range_min, :initial_range_max, :mutation_range_min, :mutation_range_max, :mutation_num
    def initialize
        # Generate initial randomized population
    end

    def fitness_function (dna)
        return -2*dna[0]**2 + -2*dna[1]**2 -4
    end

    def create
        @candidates = Array.new(@population_size) {|c| 
            candidate = Candidate.new
            candidate.dna = [Random.rand(@initial_range_min...@initial_range_max), Random.rand(@initial_range_min...@initial_range_max)]
            candidate
        }
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
            c.dna[0] = c.dna[0] + Random.rand(@mutation_range_min...@mutation_range_max)
            c.dna[1] = c.dna[1] + Random.rand(@mutation_range_min...@mutation_range_max)
        }
    end
end