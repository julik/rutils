# -*- encoding: utf-8 -*- 
# ++DEPRECATED++ - Реализует простейшую транслитерацию используя RuTranslify
require "ru_translify"

module RuTils::TransliterationStub
  
  # Транслитерирует строку в латиницу, и возвращает измененную строку
  def translify
    RuTranslify.translify(self)
  end

  # Транслитерирует строку, меняя объект  
  def translify!
    self.replace(RuTranslify.translify(self))
  end
  
  # Транслитерирует строку, делая ее пригодной для применения как имя директории или URL
  def dirify
    RuTranslify.dirify(self)
  end
end

class ::Object::String
  include RuTils::TransliterationStub
end