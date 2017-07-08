# frozen_string_literal: true

module Evopop
  # Public: Represents a candidate in the population.Evopop::Candidates are
  # abstracted as a simple data structure which contains the DNA and fitness
  # over the fitness function.
  class Candidate
    attr_accessor :dna, :fitness

    # Simple initialization of candidate object.
    def initialize(dna)
      @dna = dna
    end

    def compose_parent_dna(c0, c1)
      # Compose the dna of the first child from the first chunk of the
      # first candidate and the second chunk of the second candidate
      # dna0_left = c0.dna.take(ordinal)
      # dna1_right = c1.dna.drop(ordinal)
    end
  end
end
