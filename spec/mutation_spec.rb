# frozen_string_literal: true

require 'spec_helper'

describe Evopop::Population do
  describe '.mutate' do
    before(:all) do
      @population = Evopop::Population.new
      @population.create
      @old_candidates = Marshal.load(Marshal.dump(@population.candidates))
      @population.mutate
    end

    it 'only mutates within bounds of min and max mutation for limited population' do
      counter = 0
      @old_candidates.zip(@population.candidates).each do |old_candidate, new_candidate|
        next if old_candidate.dna == new_candidate.dna
        expect(old_candidate.dna[0] - new_candidate.dna[0]).to be <= @population.mutation_range_max
        expect(old_candidate.dna[1] - new_candidate.dna[1]).to be <= @population.mutation_range_max
        counter += 1
      end

      expect(@population.mutation_num).to be == counter
    end
  end
end
