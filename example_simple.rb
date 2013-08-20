require_relative 'candidate'
require_relative 'population'

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

print population.average_fitness