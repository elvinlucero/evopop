require 'evopop'

def drive(population)
  (0...population.max_generations).each do |i|
    population.train
    population.crossover
    if i != population.max_generations - 1
      population.mutate
    end
  end

  population
end

population = Population.new

drive population

# Sort and print out candidate with highest fitness in the last generation.
population.train
puts "Finished with the fittest candidate with a dna of #{population.candidates[0].dna} and a fitness of #{population.candidates[0].fitness}."
