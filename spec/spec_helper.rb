# frozen_string_literal: true

require 'evopop'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

# Population config used in tests
Evopop.config.population_size = 100
Evopop.config.dna_len = 2
Evopop.config.max_generations = 1000
Evopop.config.initial_range_min = -10_000.0
Evopop.config.initial_range_max = 10_000.0
Evopop.config.mutation_range_min = -100.0
Evopop.config.mutation_range_max = 100.0
Evopop.config.mutation_num = 10
Evopop.config.crossover_params = { ordinal: (Evopop.config.dna_len / 2) }
Evopop.config.crossover_function = Evopop::Crossover.method(:one_point)
Evopop.config.fitness_function = proc { |dna|
  Math.sin(dna[0]) + Math.cos(dna[1])
}
