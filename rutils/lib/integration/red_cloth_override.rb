if defined?(RedCloth)
	# RuTils выполняет перегрузку Textile Glyphs в RedCloth, перенося форматирование спецсимволов на Gilenson.
	class RedCloth  < String
		# Этот метод в RedCloth эскейпит слишком много HTML, нам ничего не оставляет :-)		
		def htmlesc(text, mode=0) #:nodoc:
			text
		end

		# А этот метод обрабатывает Textile Glyphs - ту самую типографицу.
		# Вместо того чтобы влезать в таблицы мы просто заменим Textile Glyphs - и все будут рады.	
		alias_method  :stock_pgl, :pgl
		def pgl(text) #:nodoc:
#      RuTils::overrides_enabled? ?  text.replace(RuTils::Gilenson.new(text).to_html) :  stock_pgl(text)
text.replace(RuTils::Gilenson.new(text).to_html)
		end
	end	
end