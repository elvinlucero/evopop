# Public: Represents a candidate in the population. Candidates are abstracted
# as a simple data structure which contains the DNA and fitness over the 
# fitness function.
class Candidate
  attr_accessor :dna, :fitness

  # Simple initialization of candidate object.
  def initialize
    @dna = []
  end
end
