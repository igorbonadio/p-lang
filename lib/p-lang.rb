ROOT_PATH = File.expand_path(File.dirname(__FILE__))

require File.join(ROOT_PATH, '/parser/lexer')
require File.join(ROOT_PATH, '/parser/error')
require File.join(ROOT_PATH, '/parser/token')
require File.join(ROOT_PATH, '/parser/syntax_analyser')
require File.join(ROOT_PATH, '/parser/node')

require File.join(ROOT_PATH, '/vm/interpreter')
require File.join(ROOT_PATH, '/vm/pobject')
require File.join(ROOT_PATH, '/vm/environment')
require File.join(ROOT_PATH, '/vm/plambda')