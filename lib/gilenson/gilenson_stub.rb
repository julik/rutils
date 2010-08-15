require "gilenson"

# -*- encoding: utf-8 -*- 
module RuTils
  module Gilenson
    # Позволяет возвращать класс форматтера при вызове
    #  RuTils::Gilenson.new
    def self.new(*args) #:nodoc:
      ::Gilenson.new(*args)
    end
    
    autoload :BlueClothExtra, File.dirname(__FILE__) + '/bluecloth_extra'
    autoload :RedClothExtra, File.dirname(__FILE__) + '/redcloth_extra'
    autoload :RDiscountExtra, File.dirname(__FILE__) + '/rdiscount_extra'
    autoload :MarukuExtra, File.dirname(__FILE__) + '/maruku_extra'
    autoload :Helper, File.dirname(__FILE__) + '/helper'
  end
end

# Этот класс теперь живет в геме gilenson.
class RuTils::Gilenson::Formatter < ::Gilenson
end
