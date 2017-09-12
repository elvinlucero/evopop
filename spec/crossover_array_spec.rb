# frozen_string_literal: true

require 'spec_helper'

describe CrossoverArray do
  describe '.one_point_crossover' do
    context 'when two arrays are passed in' do
      it 'returns correct arrays' do
        a = [1, 1, 1, 1, 1]
        b = [0, 0, 0, 0, 0]
        ordinal = 2

        x, y = CrossoverArray.one_point_crossover(a, b, ordinal)

        actual = { x: x, y: y }
        correct = { x: [1, 1, 1, 0, 0], y: [0, 0, 0, 1, 1] }

        expect(actual).to eq(correct)
      end
    end
  end

  describe '.two_point_crossover' do
    context 'when two arrays are passed in' do
      it 'returns correct arrays' do
        a = [1, 1, 1, 1, 1]
        b = [0, 0, 0, 0, 0]
        ordinals = [1, 3]

        x, y = CrossoverArray.two_point_crossover(a, b, ordinals)

        actual = { x: x, y: y }
        correct = { x: [1, 1, 0, 0, 1], y: [0, 0, 1, 1, 0] }

        expect(actual).to eq(correct)
      end
    end
  end

  describe '.n_point_crossover' do
    context 'when two arrays are passed in' do
      it 'returns correct arrays' do
        a = [1, 1, 1, 1, 1, 1, 1, 1]
        b = [0, 0, 0, 0, 0, 0, 0, 0]
            [1, 1, 0, 0, 1, 1, 1, 0]
        ordinals = [1, 3, 6]

        x, y = CrossoverArray.n_point_crossover(a, b, ordinals)

        actual = { x: x, y: y }
        correct = { x: [1, 1, 0, 0, 1, 1, 1, 0], y: [0, 0, 1, 1, 0, 0, 0, 1] }

        expect(actual).to eq(correct)
      end
    end
  end
end
