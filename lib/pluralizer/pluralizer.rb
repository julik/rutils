# -*- encoding: utf-8 -*- 
require "rubygems"
require "ru_propisju"

module RuTils
  module Pluralization #:nodoc:
    # Выбирает нужный падеж существительного в зависимости от числа
    def self.choose_plural(amount, *variants)
      RuPropisju.choose_plural(amount, *variants)
    end
    
    # Выводит целое или дробное число как сумму в рублях прописью
    def self.rublej(amount)
      RuPropisju.rublej(amount)
    end
    
    # Выводит целое или дробное число как сумму в гривнах прописью
    def self.griven(amount)
      RuPropisju.griven(amount)
    end
    
    def self.kopeek(amount)
      RuPropisju.kopeek(amount)
    end
    
    # Реализует вывод прописью любого объекта, реализующего Float
    module FloatFormatting
      
      # Выдает сумму прописью с учетом дробной доли. Дробная доля округляется до миллионной, или (если
      # дробная доля оканчивается на нули) до ближайшей доли ( 500 тысячных округляется до 5 десятых).
      # Дополнительный аргумент - род существительного (1 - мужской, 2- женский, 3-средний)
      def propisju(gender = 2)
        RuPropisju.propisju(self, gender)
      end

      def propisju_items(gender=1, *forms)
        RuPropisju.propisju_shtuk(self, gender, *forms)
      end

    end
    
    # Реализует вывод прописью любого объекта, реализующего Numeric
    module NumericFormatting
      # Выбирает корректный вариант числительного в зависимости от рода и числа и оформляет сумму прописью
      #   234.propisju => "двести сорок три"
      #   221.propisju(2) => "двести двадцать одна"
      def propisju(gender = 1)
        RuPropisju.propisju(self, gender)
      end
      
      def propisju_items(gender=1, *forms)
        RuPropisju.propisju_shtuk(self, gender, *forms)
      end
      
      # Выбирает корректный вариант числительного в зависимости от рода и числа. Например:
      # * 4.items("колесо", "колеса", "колес") => "колеса"
      def items(one_item, two_items, five_items)
        RuPropisju.choose_plural(self, one_item, two_items, five_items)
      end  
      
      # Выводит сумму в рублях прописью. Например:
      # * (15.4).rublej => "пятнадцать рублей сорок копеек"
      # * 1.rubl        => "один рубль"
      # * (3.14).rublja => "три рубля четырнадцать копеек"
      def rublej
        RuPropisju.rublej(self)
      end
      alias :rubl   :rublej
      alias :rublja :rublej
      
      # Выводит сумму в гривнах прописью. Например:
      # * (15.4).griven => "пятнадцать гривен сорок копеек"
      # * 1.grivna      => "одна гривна"
      # * (3.14).grivny => "три гривны четырнадцать копеек"
      def griven
        RuPropisju.griven(self)
      end
      alias :grivna :griven
      alias :grivny :griven
    end
    
    module FixnumFormatting
      def kopeek
        RuPropisju.kopeek(self)
      end
      alias :kopeika   :kopeek
      alias :kopeiki :kopeek
    end
  end
end

class Object::Numeric
  include RuTils::Pluralization::NumericFormatting
end

class Object::Fixnum
  include RuTils::Pluralization::FixnumFormatting
end

class Object::Float
  include RuTils::Pluralization::FloatFormatting
end
