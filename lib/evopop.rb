# Toplevel class for evopop project
module Evopop
  class <<self
    attr_accessor :config
  end
end

require 'evopop/population'
require 'evopop/candidate'
require 'evopop/crossover'
