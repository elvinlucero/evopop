# Public: Represents a candidate in the population. Candidates are abstracted
# as a simple data structure which contains the DNA and fitness over the 
# fitness function.
class Candidate
  attr_accessor :dna, :fitness

  # Simple initialization of candidate object.
  def initialize(dna=[])
    @dna = dna
  end
end

      # Create a child of them
      #child = Candidate.new
      # (0...@dna_len).each {|j|
      #   child.dna << (couple[0].dna[j] + couple[1].dna[j])/2.0 # Initialize the dna of the child with the average of the parents' dna.
      # }
