# frozen_string_literal: true

# Class for handling crossover against arrays.
# Supports
#   * Single point crossover
#   * n-point corssover
class CrossoverArray
  def self.one_point_crossover(a, b, ordinal)
    # Compose the dna of the first child from the first chunk of the
    # first candidate and the second chunk of the second candidate
    dna_a_left = a[0..ordinal]
    dna_b_right = b[(ordinal + 1)..-1]

    # Compose the dna of the second child from the first chunk of the
    # first candidate and the second chunk of the second candidate
    dna_b_left = b[0..ordinal]
    dna_a_right = a[(ordinal + 1)..-1]

    [dna_a_left + dna_b_right, dna_b_left + dna_a_right]
  end

  def self.two_point_crossover(cdna_a, cdna_b, ordinals)
    dna_a = combine_on_ordinal(cdna_a, cdna_b, ordinals)
    dna_b = combine_on_ordinal(cdna_b, cdna_a, ordinals)

    [dna_a, dna_b]
  end

  def self.n_point_crossover(dna_a, dna_b, ordinals)
    ret_a = []
    ret_b = []

    old_ordinal = 0
    toggle = true
    ordinals << dna_a.length + 1

    ordinals.each do |ordinal|
      if toggle
        ret_a += dna_a[old_ordinal..ordinal]
        ret_b += dna_b[old_ordinal..ordinal]
      else
        ret_a += dna_b[old_ordinal..ordinal]
        ret_b += dna_a[old_ordinal..ordinal]
      end

      old_ordinal = ordinal + 1
      toggle = !toggle
    end

    [ret_a, ret_b]
  end

  def self.combine_on_ordinal(dna_a, dna_b, ordinals)
    dna_a[0..ordinals[0]] + dna_b[(ordinals[0] + 1)..ordinals[1]] + dna_a[(ordinals[1] + 1)..dna_a.length - 1]
  end

  def self.build_dna_by_synchronous(cdna_a, cdna_b, pdna_a, pdna_b, ordinal_range, synchronous)
    pdnas = [pdna_a, pdna_b]
    pdnas.reverse! unless synchronous
    cdna_a += pdnas[0][ordinal_range]
    cdna_b += pdnas[1][ordinal_range]

    [cdna_a, cdna_b]
  end
end
