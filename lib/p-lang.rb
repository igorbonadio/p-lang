ROOT_PATH = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'treetop'

Treetop.load ROOT_PATH + '/parser/p-lang'
