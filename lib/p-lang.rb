ROOT_PATH = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'treetop'

Treetop.load File.join(ROOT_PATH, '/parser/p-lang')

require File.join(ROOT_PATH, '/parser/nodes')
require File.join(ROOT_PATH, '/parser/ast')

require File.join(ROOT_PATH, '/vm/environment')
require File.join(ROOT_PATH, '/vm/vm')
require File.join(ROOT_PATH, '/vm/proc')
require File.join(ROOT_PATH, '/vm/pobject')
require File.join(ROOT_PATH, '/vm/perror')

require File.join(ROOT_PATH, '/vm/std/pio')
require File.join(ROOT_PATH, '/vm/std/pstring')

module PLang  
  class VM
    def initialize_global_environment(env)
      PIO.def_pfunctions(env)
      PString.def_pfunctions(env)
    end
  end
end