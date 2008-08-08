# RuTils выполняет перегрузку Textile Glyphs в RedCloth, перенося форматирование спецсимволов на Gilenson.
class RedCloth  < String #:nodoc:
  # Этот метод в RedCloth при наличии Гиленсона надо отключать    
  alias_method  :htmlesc_without_rutils, :htmlesc
  def htmlesc(text, mode=0) #:nodoc:
    RuTils::overrides_enabled? ?  text :  htmlesc_without_rutils(text, mode)
  end
  
  # А этот метод обрабатывает Textile Glyphs - ту самую типографицу.
  # Вместо того чтобы влезать в чужие таблицы мы просто заменим Textile Glyphs на Gilenson - и все будут рады.  
  alias_method  :pgl_without_rutils, :pgl
  def pgl(text) #:nodoc:
    if RuTils::overrides_enabled?
      # Suspend the spaces in the start and end of the block because Gilenson chews them off, 
      # and RedCloth feeds them to us in packs
      # that appear between tag starts/stops. We mess up the formatting but preserve the spacing.
      spaces =  Array.new(2,'')
      text.gsub!(/\A([\s]+)/) { spaces[0] = $1; '' }
      text.gsub!(/(\s+)\Z/) { spaces[1] = $1; '' }
      text.replace(spaces[0].to_s + RuTils::Gilenson::Formatter.new(text).to_html + spaces[1].to_s)
    else
      pgl_without_rutils(text)
    end
  end
end