# frozen_string_literal: true

module Evopop
  # Represents a collection of well known crossover functions.
  #
  module Crossover
    # Perform 1 point crossover for a pair of candidates at the ordinal.
    # http://en.wikipedia.org/wiki/Crossover_(genetic_algorithm)#One-point_crossover
    def self.one_point(candidates, params)
      ordinal = params[:ordinal]

      # Compose the dna of the first child from the first chunk of the
      # first candidate and the second chunk of the second candidate
      dna_a_left = candidates[0].dna.take(ordinal)
      dna_b_right = candidates[1].dna.drop(ordinal)

      # Compose the dna of the second child from the first chunk of the
      # first candidate and the second chunk of the second candidate
      dna_b_left = candidates[1].dna.take(ordinal)
      dna_a_right = candidates[0].dna.drop(ordinal)

      min_range = candidates[0].dna.min_range
      max_range = candidates[1].dna.max_range

      min_mutation = candidates[1].dna.min_mutation
      max_mutation = candidates[1].dna.max_mutation

      dna_a = Evopop::Dna.create(min_range, max_range, min_mutation, max_mutation, dna_a_left + dna_b_right)
      dna_b = Evopop::Dna.create(min_range, max_range, min_mutation, max_mutation, dna_b_left + dna_a_right)

      # Initialize and assign DNA to children.
      children = [
        Evopop::Candidate.new(dna_a),
        Evopop::Candidate.new(dna_b)
      ]

      children
    end

    # Perform two point crossover over a pair of candidates. Will output two
    # children with genes spliced over the crossover points.

    def self.two_point(candidates, params)
      # Ordinals should be stored in params as a comma separated list. I.e. "1,2".
      # Make sure to sort.
      ordinals = params[:ordinals].split(',').sort.collect(&:to_i)

      # Initialize and assign the DNA of the children.
      cdna_a = candidates[0].dna
      cdna_b = candidates[1].dna

      children = [
        Evopop::Candidate.new(
          cdna_a[0..ordinals[0]] +
          cdna_b[(ordinals[0] + 1)..ordinals[1]] + cdna_a[(ordinals[1] + 1)..cdna_a.length - 1]
        ),
        Evopop::Candidate.new(
          cdna_b[0..ordinals[0]] +
          cdna_a[(ordinals[0] + 1)..ordinals[1]] + cdna_b[(ordinals[1] + 1)..cdna_b.length - 1]
        )
      ]

      children
    end

    # Perform n_point crossover for a pair of candidates. Will output two children from the n_point crossover.
    #
    # Example:
    # n_point
    def self.n_point(candidates, params)
      ordinals = params[:ordinals].split(',').sort.collect(&:to_i)

      pdna_a = candidates[0].dna
      pdna_b = candidates[1].dna

      dna_length = candidates[0].dna.length

      cdna_a = []
      cdna_b = []

      old_ordinal = 0
      synchronous = ordinals[0] == 0 ? false : true

      ordinals.each do |i|
        if synchronous
          cdna_a += pdna_a[old_ordinal..i]
          cdna_b += pdna_b[old_ordinal..i]
        else
          cdna_a += pdna_b[old_ordinal..i]
          cdna_b += pdna_a[old_ordinal..i]
        end

        synchronous = !synchronous
        old_ordinal = i + 1

        next if ordinals.last != old_ordinal - 1

        if synchronous
          cdna_a += pdna_a[old_ordinal..dna_length - 1]
          cdna_b += pdna_b[old_ordinal..dna_length - 1]
        else
          cdna_a += pdna_b[old_ordinal..dna_length - 1]
          cdna_b += pdna_a[old_ordinal..dna_length - 1]
        end
      end

      [Evopop::Candidate.new(cdna_a), Evopop::Candidate.new(cdna_b)]
    end

    def self.average(candidates, _params)
      new_dna = Evopop::Dna.new(
        candidates[0].dna.min_range,
        candidates[0].dna.max_range,
        candidates[0].dna.min_mutation,
        candidates[0].dna.max_mutation,
        candidates[0].dna.length
      )
      new_dna.dna = []
      (0...candidates[0].dna.length).each do |j|
        # Initialize the dna of the child with the average of the parents' dna.
        new_dna.dna << (candidates[0].dna[j] + candidates[1].dna[j]) / 2.0
      end
      [Evopop::Candidate.new(new_dna)]
    end
  end
end
