if defined?(Object::RedCloth)
  # RuTils выполняет перегрузку Textile Glyphs в RedCloth, перенося форматирование спецсимволов на Gilenson.
  class Object::RedCloth  < String #:nodoc:
    # Этот метод в RedCloth эскейпит слишком много HTML, нам ничего не оставляет :-)    
    alias_method  :stock_htmlesc, :htmlesc
    def htmlesc(text, mode=0) #:nodoc:
      RuTils::overrides_enabled? ?  text :  stock_htmlesc(text, mode)
    end

    # А этот метод обрабатывает Textile Glyphs - ту самую типографицу.
    # Вместо того чтобы влезать в таблицы мы просто заменим Textile Glyphs - и все будут рады.  
    alias_method  :stock_pgl, :pgl
    def pgl(text) #:nodoc:
      RuTils::overrides_enabled? ?  text.replace(RuTils::Gilenson::Formatter.new(text).to_html) :  stock_pgl(text)
    end
  end 
end