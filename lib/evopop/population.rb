
# Represents the population that is being trained. Has various methods
# relevant to training.
# 
#
# Examples
#   population = Population.new
#   ... initialize population with parameters ...
#   population.train
#   population.crossover
#   population.mutate
class Population
  attr_accessor :candidates, :population_size, :max_generations, :initial_range_min, :initial_range_max, :mutation_range_min, :mutation_range_max, :mutation_num, :fitness_function, :dna_len, :average_fitness

  # Initializes the attributes with default values. This is not guaranteed
  # to reach maxima.
  def initialize
    @average_fitness = []
    @population_size = 100
    @max_generations = 100
    @initial_range_min = -100
    @initial_range_max = 100
    @mutation_range_min = -10
    @mutation_range_max = 10
    @mutation_num = (0.10*@population_size).to_i
    @dna_len = 1

    @fitness_function = Proc.new { |dna|
      Math.sin(dna[0])
    }

    self.create
  end

  # Creates a new population class. Should be called after all the
  # parameters have been set to the attributes.
  def create
    @candidates = Array.new(@population_size) {|c| 
      candidate = Candidate.new
      (0...@dna_len).each {
        candidate.dna << Random.rand(@initial_range_min...@initial_range_max)
      }
      candidate
    }
  end

  # Determines the fitness of the population and thereafter sorts it
  # based on fitness descdending (high fitness first, low fitness last).
  def train
    average_fitness = 0
    @candidates.each { |c|
      c.fitness = fitness_function.call(c.dna)
      average_fitness = average_fitness + c.fitness
    }
    average_fitness = average_fitness/@population_size

    @average_fitness << average_fitness

    @candidates = @candidates.sort_by {|c| c.fitness}
    @candidates = @candidates.reverse
  end

  # Performs simple mechanism of crossover - in this case picks two
  # random candidates in from a top percentile of the population and 
  # performs one point crossover, producing new offspring equal to the
  # population size attribute.
  def crossover
    @candidates = @candidates.take((@population_size*0.75).to_i)
    
    new_generation = Array.new
    
    (0...@population_size).each {|i|
      # For each of the top 75% of the population take 2
      couple = @candidates.sample(2)

      children = Crossover.one_crossover(couple, self.dna_len/2)

      new_generation = new_generation + children
      
      if new_generation.length >= self.population_size
        new_generation = new_generation.take(self.population_size)
        break
      end
    }
    @candidates = new_generation
  end

  # Performs simple mutation over the next generation. In this case, 
  # it either adds or substracts an amount to each dimension given the 
  # mutation range attributes.
  def mutate
    mutated = @candidates.sample(self.mutation_num)

    mutated.each { |c|
      (0...@dna_len).each {|i|
        c.dna[i] = c.dna[i] + Random.rand(@mutation_range_min...@mutation_range_max)
      }
    }
  end
end
