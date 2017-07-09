# frozen_string_literal: true

require 'spec_helper'

describe Evopop::Population do
  describe '.train' do
    before(:all) do
      @population = Evopop::Population.new
      @population.create
      @population.train
    end

    it 'has sorted candidates of population by fitness' do
      @population.candidates.length.times do |count|
        expect(@population.candidates[count].fitness.nil?).not_to be_nil

        next if count <= 0
        expect(@population.candidates[count].fitness).to be <= @population.candidates[count - 1].fitness
      end
    end
  end
end
