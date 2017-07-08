module Evopop
  class Dna
    attr_accessor :dna, :min_range, :max_range
    def initialize(min_range, max_range, dna_len)
      @dna_len = dna_len
      @min_range = min_range
      @max_range = max_range
      @dna = []
      dna_len_range.each do |i|
        @dna << random_dna_val
      end
    end

    def self.create(min_range, max_range, dna)
      new_dna = new(min_range, max_range, dna.size)
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

    def length
      @dna.length
    end

    def take(num)
      @dna.take(num)
    end

    def mutate(i)
      self[i] += random_dna_val
    end

    def drop(ordinal)
      @dna.drop(ordinal)
    end
  end
end
