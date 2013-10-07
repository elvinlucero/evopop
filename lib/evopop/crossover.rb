# Represents a collection of well known crossover functions.
# 
module Crossover

  # Perform 1 point crossover for a pair of candidates at the ordinal.
  # 
  def self.one_crossover(candidates, ordinal)
    # Compose the dna of the first child from the first chunk of the 
    # first candidate and the second chunk of the second candidate
    dna0_left = candidates[0].dna.take(ordinal)
    dna1_right = candidates[1].dna.drop(ordinal)

    
    # Compose the dna of the second child from the first chunk of the 
    # first candidate and the second chunk of the second candidate
    dna1_left = candidates[1].dna.take(ordinal)
    dna0_right = candidates[0].dna.drop(ordinal)

    children = [Candidate.new, Candidate.new]
    children[0].dna = dna0_left + dna1_right
    children[1].dna = dna1_left + dna0_right

    puts (dna0_left + dna1_right).to_s
    children = [Candidate.new(:dna => dna0_left + dna1_right), 
                Candidate.new(:dna => dna1_left + dna0_right)]


    return children
  end


  # Perform n_point crossover for a pair of candidates. Will output two children from the n_point crossover.
  # 
  # Example:
  # n_point
  def n_point(candidates, ordinals)

  end

end