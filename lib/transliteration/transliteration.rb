# -*- encoding: utf-8 -*- 
module RuTils
  module Transliteration #:nodoc:
  end
end

require File.join(File.dirname(__FILE__), 'simple')

# Заглушка
require File.join(File.dirname(__FILE__), 'bidi')
    
# Реализует транслитерацию любого объекта, реализующего String или to_s
module RuTils::Transliteration::StringFormatting
  
  # Транслитерирует строку в латиницу, и возвращает измененную строку
  def translify
    RuTils::Transliteration::Simple::translify(self.to_s)
  end

  # Транслитерирует строку, меняя объект  
  def translify!
    self.replace(self.translify)
  end
  
  # Транслитерирует строку, делая ее пригодной для применения как имя директории или URL
  def dirify
    RuTils::Transliteration::Simple::dirify(self.to_s)
  end
  
  # ++DEPRECATED++ Вызывает ошибку
  def bidi_translify(allow_slashes = true)
    RuTils::Transliteration::BiDi.bail!
  end
  
  # ++DEPRECATED++ Вызывает ошибку
  def bidi_translify!(allow_slashes = true)
    RuTils::Transliteration::BiDi.bail!
  end

  # ++DEPRECATED++ Вызывает ошибку
  def bidi_detranslify!(allow_slashes = true)
    RuTils::Transliteration::BiDi.bail!
  end
  
  # ++DEPRECATED++ Вызывает ошибку
  def bidi_detranslify(allow_slashes = true)
    RuTils::Transliteration::BiDi.bail!
  end
end

class Object::String
  include RuTils::Transliteration::StringFormatting
end