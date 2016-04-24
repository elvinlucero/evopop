module Evopop
  # Represents the population that is being trained. Has various methods
  # relevant to training.
  #
  #
  # Examples
  #   population = Evopop::Population.new
  #   ... initialize population with parameters ...
  #   population.train
  #   population.crossover
  #   population.mutate
  class Population
    attr_accessor :candidates, :population_size, :max_generations, :crossover_function, :crossover_params, :initial_range_min, :initial_range_max, :mutation_range_min, :mutation_range_max, :mutation_num, :fitness_function, :dna_len, :average_fitness

    # Initializes the attributes with default values. This is not guaranteed
    # to reach maxima.
    def initialize
      Evopop.config.instance_variables.each do |iv|
        instance_variable_set(
          iv,
          Evopop.config.instance_variable_get(iv)
        )
      end
      create
      self
    end

    # Creates a new population class. Should be called after all the
    # parameters have been set to the attributes.
    def create
      @candidates = Array.new(@population_size) do
        candidate = Evopop::Candidate.new
        (0...@dna_len).each do
          candidate.dna << Random.rand(@initial_range_min...@initial_range_max)
        end
        candidate
      end
    end

    # Determines the fitness of the population and thereafter sorts it
    # based on fitness descdending (high fitness first, low fitness last).
    def train
      average_fitness = 0
      @candidates.each do |c|
        c.fitness = fitness_function.call(c.dna)
        average_fitness += + c.fitness
      end

      average_fitness /= @population_size

      @average_fitness << average_fitness

      @candidates = @candidates.sort_by(&:fitness)
      @candidates = @candidates.reverse
    end

    # Performs simple mechanism of crossover - in this case picks two
    # random candidates in from a top percentile of the population and
    # performs one point crossover, producing new offspring equal to the
    # population size attribute.
    def crossover
      # Define the candidates that can have children.
      @candidates = @candidates.take((@population_size * 0.75).to_i)

      new_generation = []

      (0...@population_size).each do
        # For each of the top 75% of the population take 2
        couple = @candidates.sample(2)
        params = @crossover_params

        children = @crossover_function.call(couple, params)

        new_generation += children

        # When we go above set population_size, take the first population_size
        # candidates, ignore the rest.
        if new_generation.length >= population_size
          new_generation = new_generation.take(population_size)
          break
        end
      end

      @candidates = new_generation
    end

    # Performs simple mutation over the next generation. In this case,
    # it either adds or substracts an amount to each dimension given the
    # mutation range attributes.
    def mutate
      mutated = @candidates.sample(mutation_num)

      mutated.each do |c|
        (0...@dna_len).each do |i|
          c.dna[i] = c.dna[i] + Random.rand(@mutation_range_min...@mutation_range_max)
        end
      end
    end
  end
end
