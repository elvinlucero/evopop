module Evopop
  class Dna
    attr_accessor :dna, :min_range, :max_range, :min_mutation, :max_mutation
    def initialize(min_range, max_range, min_mutation, max_mutation, dna_len)
      @dna_len = dna_len
      @min_range = min_range
      @max_range = max_range
      @min_mutation = min_mutation
      @max_mutation = max_mutation
      @dna = []

      dna_len_range.each do
        @dna << random_dna_val
      end
    end

    def self.create(min_range, max_range, min_mutation, max_mutation, dna)
      new_dna = new(min_range, max_range, min_mutation, max_mutation, dna.size)
      new_dna.dna = dna
      new_dna
    end

    def [](key)
      @dna[key]
    end

    def []=(key, value)
      @dna[key] = value
    end

    def dna_len_range
      0...@dna_len
    end

    def random_dna_val
      Random.rand(@min_range...@max_range)
    end

    def random_mutation_val
      Random.rand(@min_mutation...@max_mutation)
    end

    def length
      @dna.length
    end

    def take(num)
      @dna.take(num)
    end

    def mutate(i)
      @dna[i] += [random_mutation_val, -1 * random_mutation_val].sample
    end

    def drop(ordinal)
      @dna.drop(ordinal)
    end
  end
end
