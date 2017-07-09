# frozen_string_literal: true

require 'spec_helper'

describe Evopop::Population do
  describe '.new' do
    before(:all) do
      @population = Evopop::Population.new
      @population.create
    end

    it 'has the right properties' do
      expect(@population.candidates.length).to eq(@population.population_size)
    end

    it 'has fitness function of Proc' do
      expect(@population.fitness_function.is_a?(Proc)).to eq(true)
    end

    it 'has a population that conforms to DNA settings' do
      @population.candidates.each do |c|
        expect(c.dna.length).to eq(@population.dna_len)
        expect(c.dna[0]).to be > @population.initial_range_min
        expect(c.dna[0]).to be < @population.initial_range_max
        expect(c.dna[1]).to be > @population.initial_range_min
        expect(c.dna[1]).to be < @population.initial_range_max
      end
    end
  end
end
