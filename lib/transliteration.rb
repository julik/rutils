# -*- encoding: utf-8 -*- 
# ++DEPRECATED++ - Реализует простейшую транслитерацию используя Russian
require "ru_translify"

module RuTils::TransliterationStub
  
  # Транслитерирует строку в латиницу, и возвращает измененную строку
  def translify
    Russian.transliterate(self)
  end

  # Транслитерирует строку, меняя объект  
  def translify!
    self.replace(Russian.transliterate(self))
  end
  
  # Транслитерирует строку, делая ее пригодной для применения как имя директории или URL
  def dirify
    st = translify
    st.gsub!(/(\s\&\s)|(\s\&amp\;\s)/, ' and ') # convert & to "and"
    st.gsub!(/\W/, ' ')  #replace non-chars
    st.gsub!(/(_)$/, '') #trailing underscores
    st.gsub!(/^(_)/, '') #leading unders
    st.strip.gsub(/(\s)/,'-').downcase.squeeze('-')
  end
end

class ::Object::String
  include RuTils::TransliterationStub
end