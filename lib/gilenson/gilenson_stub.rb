# -*- encoding: utf-8 -*- 

require "gilenson"

module RuTils
  module GilensonStub
    
    # Позволяет возвращать класс форматтера при вызове
    #  RuTils::Gilenson.new
    def self.new(*args) #:nodoc:
      Gilenson.new(*args)
    end
    
    # Включается на правах хелпера в Rails-приложение
    module Helper
      
      # Возвращает текст обработанный Гиленсоном
      def gilensize(text, options = {})
        return "" if text.blank?
        f = Gilenson.new
        f.configure!(options)
        f.process(text)
      end
      
      # Возвращает текст обработанный Текстилем и Гиленсоном
      # <i>Метод доступен только при включенном RedCloth</i>
      def textilize(text)
        return "" if text.blank?
        require 'redcloth'
        if RuTils.overrides_enabled?
          Gilenson::RedClothExtra.new(text, [ :hard_breaks ]).to_html
        else
          super(text)
        end
      end
      
      # Возвращает текст с кодом Markdown превращенным в HTML, попутно обработанный Гиленсоном
      # <i>Метод доступен только при наличии BlueCloth</i>.
      def markdown(text)
        return "" if text.blank?
        require 'bluecloth'
        RuTils.overrides_enabled? ? Gilenson.new(super(text)).to_html : super
      end
    end
  end
end