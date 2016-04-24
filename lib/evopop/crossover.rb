# Represents a collection of well known crossover functions.
#
module Crossover

  # Perform 1 point crossover for a pair of candidates at the ordinal.
  # http://en.wikipedia.org/wiki/Crossover_(genetic_algorithm)#One-point_crossover
  def self.one_point(candidates, params)
    ordinal = params[:ordinal]

    # Compose the dna of the first child from the first chunk of the
    # first candidate and the second chunk of the second candidate
    dna0_left = candidates[0].dna.take(ordinal)
    dna1_right = candidates[1].dna.drop(ordinal)

    # Compose the dna of the second child from the first chunk of the
    # first candidate and the second chunk of the second candidate
    dna1_left = candidates[1].dna.take(ordinal)
    dna0_right = candidates[0].dna.drop(ordinal)

    # Initialize and assign DNA to children.
    children = [Candidate.new(dna0_left + dna1_right),
                Candidate.new(dna1_left + dna0_right)]

    children
  end

  # Perform two point crossover over a pair of candidates. Will output two
  # children with genes spliced over the crossover points.

  def self.two_point(candidates, params)
    # Ordinals should be stored in params as a comma separated list. I.e. "1,2".
    # Make sure to sort.
    ordinals = params[:ordinals].split(',').sort.collect(&:to_i)

    # Initialize and assign the DNA of the children.
    cdna0 = candidates[0].dna
    cdna1 = candidates[1].dna

    children = [Candidate.new(cdna0[0..ordinals[0]] + cdna1[(ordinals[0] + 1)..ordinals[1]] + cdna0[(ordinals[1] + 1)..cdna0.length-1]),
                Candidate.new(cdna1[0..ordinals[0]] + cdna0[(ordinals[0] + 1)..ordinals[1]] + cdna1[(ordinals[1] + 1)..cdna1.length-1])]

    children
  end

  # Perform n_point crossover for a pair of candidates. Will output two children from the n_point crossover.
  #
  # Example:
  # n_point
  def self.n_point(candidates, params)
    ordinals = params[:ordinals].split(',').sort.collect(&:to_i)

    pdna0 = candidates[0].dna
    pdna1 = candidates[1].dna

    dna_length = candidates[0].dna.length

    cdna0 = []
    cdna1 = []

    old_ordinal = 0
    synchronous = ordinals[0] == 0 ? false : true

    ordinals.each do |i|
      if synchronous
        cdna0 += pdna0[old_ordinal..i]
        cdna1 += pdna1[old_ordinal..i]
      else
        cdna0 += pdna1[old_ordinal..i]
        cdna1 += pdna0[old_ordinal..i]
      end

      synchronous = !synchronous
      old_ordinal = i + 1

      next if ordinals.last != old_ordinal - 1

      if synchronous
        cdna0 += pdna0[old_ordinal..dna_length - 1]
        cdna1 += pdna1[old_ordinal..dna_length - 1]
      else
        cdna0 += pdna1[old_ordinal..dna_length - 1]
        cdna1 += pdna0[old_ordinal..dna_length - 1]
      end
    end

    [Candidate.new(cdna0), Candidate.new(cdna1)]
  end

  def self.average(candidates, _params)
    child = Candidate.new
    dna_length = candidates[0].dna.length

    (0...dna_length).each do |j|
      # Initialize the dna of the child with the average of the parents' dna.
      child.dna << (candidates[0].dna[j] + candidates[1].dna[j]) / 2.0
    end

    [child]
  end
end
