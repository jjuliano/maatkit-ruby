  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  require 'tempfile'

  Dir[File.join(File.dirname(__FILE__), 'maatkit-ruby/**/*.rb')].sort.reverse.each { |lib| require lib }

