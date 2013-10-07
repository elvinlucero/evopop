# Represents a collection of well known crossover functions.
# 
module Crossover

  # Perform 1 point crossover for a pair of candidates at the ordinal.
  # 
  def crossover (candidates, ordinal)
    # Compose the first child from the first chunk of the first candidate
    # and the second chunk of the second candidate
    dna0_left = candidates[0].dna.take(ordinal)
    dna1_right = candidates[1].dna.drop(ordinal)
    candidate1 = Candidate.new 
    candidate1.dna = dna0_left + dna_1_right
    
    # Compose the second child from the first chunk of the second candidate
    # and the second chunk of the first candidate
    dna1_left = candidates[1].dna.take(ordinal)
    dna0_right = candidates[0].dna.drop(ordinal)
    candidate2 = Candidate.new
    candidate2.dna = dna1_left + dna_0_right

    return [candidate1, candidate2]
  end


  # Perform n_point crossover for a pair of candidates. Will output two children from the n_point crossover.
  # 
  # Example:
  # n_point
  def n_point (candidates, ordinals)

  end

end