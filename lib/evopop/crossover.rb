# frozen_string_literal: true

module Evopop
  # Represents a collection of well known crossover functions.
  #
  module Crossover
    # Perform 1 point crossover for a pair of candidates at the ordinal.
    # http://en.wikipedia.org/wiki/Crossover_(genetic_algorithm)#One-point_crossover
    def self.one_point(candidates, params)
      ordinal = params[:ordinal]
      arr_a, arr_b = CrossoverArray.one_point_crossover(candidates[0].dna, candidates[1].dna, ordinal)

      # TODO: Move this to its own class, DnaRange
      min_range = candidates[0].dna.min_range
      max_range = candidates[1].dna.max_range

      # TODO: Move this to its own class, DnaMutationRange
      min_mutation = candidates[1].dna.min_mutation
      max_mutation = candidates[1].dna.max_mutation

      dna_a = Evopop::Dna.create(min_range, max_range, min_mutation, max_mutation, arr_a)
      dna_b = Evopop::Dna.create(min_range, max_range, min_mutation, max_mutation, arr_b)

      # Initialize and assign DNA to children.
      [
        Evopop::Candidate.new(dna_a),
        Evopop::Candidate.new(dna_b)
      ]
    end

    # Perform two point crossover over a pair of candidates. Will output two
    # children with genes spliced over the crossover points.

    def self.two_point(candidates, params)
      # Ordinals should be stored in params as a comma separated list. I.e. "1,2".
      # Make sure to sort.
      ordinals = params[:ordinals].split(',').sort.collect(&:to_i)

      cdna_a, cdna_b = CrossoverArray.two_point_crossover(candidates[0].dna, candidates[1].dna, ordinals)

      [
        Evopop::Candidate.new(cdna_a),
        Evopop::Candidate.new(cdna_b)
      ]
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
        n_ordinal = old_ordinal..i

        cdna_a, cdna_b = CrossoverArray.build_dna_by_synchronous(cdna_a, cdna_b, pdna_a, pdna_b, n_ordinal, synchronous)

        synchronous = !synchronous
        next_ordinal = i + 1

        next if ordinals.last != next_ordinal - 1

        ordinal_range = next_ordinal..(dna_length - 1)
        cdna_a, cdna_b = CrossoverArray.build_dna_by_synchronous(
          cdna_a, cdna_b,
          pdna_a, pdna_b,
          ordinal_range, synchronous
        )
      end

      [
        Evopop::Candidate.new(cdna_a),
        Evopop::Candidate.new(cdna_b)
      ]
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
