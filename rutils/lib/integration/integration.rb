if defined?(RedCloth)
	# RuTils выполняет перегрузку Textile Glyphs в RedCloth, перенося форматирование спецсимволов на Gilenson.
	class RedCloth  < String
		# Этот метод в RedCloth эскейпит слишком много HTML, нам ничего не оставляет :-)		
		def htmlesc(text, mode=0)
			text
		end
		
		# А этот метод обрабатывает Textile Glyphs - ту самую типографицу.
		# Вместо того чтобы влезать в таблицы мы просто заменим Textile Glyphs - и все будут рады.	
		def pgl(text)
			text.replace RuTils::Gilenson.new(text).to_html
		end
	end	
end

if defined?(BlueCloth)
	class BlueCloth < String
		alias_method :old_to_html, :to_html
		def to_html(*opts)
			RuTils::Gilenson.new(old_to_html(*opts)).to_html
		end
	end
end