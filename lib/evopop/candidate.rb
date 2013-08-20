# Public: Represents a candidate in the population. Candidates are abstracted
# as a simple data structure which contains the DNA and fitness over the 
# fitness function.
class Candidate
  attr_accessor :dna, :fitness

  def initialize
    @dna = []
  end
end
