module RuTils
	class GilensonX < String

			# Задача (вкратце) состоит в том чтобы все ступени разработки развести в отдельные методы
			# и тестировать их отдельно друг от друга (а также иметь возможность их по-одному включать и выключать).
			# Фильтры, которые начинаются с lift работают с блоком (например - вытащить таги, провести обработку
			# текста и вернуть все назад)
						
			# Фильтры обрабатываются именно в таком порядке. Этот массив стравнивается с настройками, и если настройки
			# для конкретного фильтра установлены в false этот фильтр обработан не будет.
			# Каждый фильтр должен именоваться process_{filter}, принимать аргументом текст для обработки и возвращать его же!
			# После того как фильтр включен в этот массив и для него написан метод фильтр по лумолчанию включается,
			# и его настройку можно поменять с помощью аксессора с соотв. именем
			
			@@order_of_filters = [
					:inches,
					:simple_quotes,
					:typographer_quotes,
					:dashes,
					:emdashes,
					:plusmin,
					:degrees,
					:phones,
			]			

			private

			def to_html(*opts)
				text = lift_tags(self.to_s) do | text |
					lift_ignored(text) do |text|
						for filter in @@order_of_filters

							raise "UnknownFilter #process_#{filter}!" unless self.respond_to?("process_#{filter}".to_sym)
							
							self.send("process_#{filter}".to_sym, text) if @settings[filter.to_sym] # вызываем конкретный фильтр
						end
					end
				end
			end
				
			# Вытаскивает теги из текста, выполняет переданный блок и возвращает теги на место.
			# Теги заменяются на специальный маркер			
			def lift_tags(text, &block)
		    tags = []
				
				# Выцепляем таги
	 #	re =  /<\/?[a-z0-9]+("+ # имя тага
	 #                              "\s+("+ # повторяющая конструкция: хотя бы один разделитель и тельце
	 #                                     "[a-z]+("+ # атрибут из букв, за которым может стоять знак равенства и потом
	 #                                              "=((\'[^\']*\')|(\"[^\"]*\")|([0-9@\-_a-z:\/?&=\.]+))"+ # 
	 #                                           ")?"+
	 #                                  ")?"+
	 #                            ")*\/?>|\xA2\xA2[^\n]*?==/i;

			  re =  /<\/?[a-z0-9]+(\s+([a-z]+(=((\'[^\']*\')|(\"[^\"]*\")|([0-9@\-_a-z:\/?&=\.]+)))?)?)*\/?>|\xA2\xA2[^\n]*?==/ui
	      text.scan(re) do | match |
		      match = "&lt;" + match if @settings["html"]
					tags << match
				end

		    text.gsub!(re, "\200") #маркер тега
				
				text = yield(text) if block_given? #делаем все что надо сделать без тегов
				
		    # Вставляем таги обратно.
				while tag = tags.shift do
					text.sub!("\200", tag)
				end
				text
			end

			# Выцепляет игнорированные символы, выполняет блок с текстом
			# без этих символов а затем вставляет их на место			
			def lift_ignored(text, &block)
		    ignored = []		
				text.scan(@ignore) do |result|
		      puts "Got ignored" 
					ignored << result
				end
		    text.gsub!(@ignore, "\201")
				
				# обрабатываем текст
				text = yield(text) if block_given?				
				
				# возвращаем игнорированные символы
				while skipped = ignored.shift do						
						text.sub!("\201", skipped)
				end
				text
			end

			# Кавычки - лапки			
			def process_simple_quotes(text)
		      text.gsub!( /\"\"/ui, "&quot;&quot;")
		      text.gsub!( /\"\.\"/ui, "&quot;.&quot;")
		      _text = '""';
		      while _text != text do  
		        _text = text
		        text.gsub!( /(^|\s|\201|\200|>)\"([0-9A-Za-z\'\!\s\.\?\,\-\&\;\:\_\200\201]+(\"|&#148;))/ui, '\1&#147;\2')
						#this doesnt work in-place. somehow.
		        text.replace text.gsub( /(\&\#147\;([A-Za-z0-9\'\!\s\.\?\,\-\&\;\:\200\201\_]*).*[A-Za-z0-9][\200\201\?\.\!\,]*)\"/ui, '\1&#148;')
		      end
			end
			
			# Кавычки - елочки
			def process_typographer_quotes(text)
		    # 2. ёлочки
	      text.gsub!( /\"\"/ui, "&quot;&quot;");
	      text.gsub!( /(^|\s|\201|\200|>|\()\"((\201|\200)*[~0-9ёЁA-Za-zА-Яа-я\-:\/\.])/ui, "\\1&laquo;\\2");
	      # nb: wacko only regexp follows:
	      text.gsub!( /(^|\s|\201|\200|>|\()\"((\201|\200|\/&nbsp;|\/|\!)*[~0-9ёЁA-Za-zА-Яа-я\-:\/\.])/ui, "\\1&laquo;\\2")
	      _text = "\"\"";
	      while (_text != text) do
					_text = text;
	        text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\201|\200)*)\"/sui, "\\1&raquo;")
	        # nb: wacko only regexps follows:
	        text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\201|\200)*\?(\201|\200)*)\"/sui, "\\1&raquo;")
	        text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\201|\200|\/|\!)*)\"/sui, "\\1&raquo;")
	      end
			end
			
			# Cложные кавычки
			def process_compound_quotes(text)
        text.gsub!(/(\&\#147\;(([A-Za-z0-9'!\.?,\-&;:]|\s|\200|\201)*)&laquo;(.*)&raquo;)&raquo;/ui,"\\1&#148;");
			end

			# Обрабатывает короткое тире
			def process_dashes(text)
	      text.gsub!( /(\s|;)\-(\s)/ui, "\\1&ndash;\\2")
			end
			
			# Обрабатывает длинные тире			
			def process_emdashes(text)
	      text.gsub!( /(\s|;)\-\-(\s)/ui, "\\1&mdash;\\2")
			end

			# Обрабатывает знаки копирайта, торговой марки и т.д.
			def process_specials(text)
	      # 4. (с)
	      text.gsub!(/\([сСcC]\)((?=\w)|(?=\s[0-9]+))/u, "&copy;") if @settings["(c)"]
	      # 4a. (r)
	      text.gsub!( /\(r\)/ui, "<sup>&#174;</sup>") if @settings["(r)"]

	      # 4b. (tm)
	      text.gsub!( /\(tm\)|\(тм\)/ui, "&#153;") if @settings["(tm)"]
	      # 4c. (p)   
	      text.gsub!( /\(p\)/ui, "&#167;") if @settings["(p)"]
			end
						
			# Склейка дефисоов
			def process_glue(text)
		    text.gsub!( /([a-zа-яА-Я0-9]+(\-[a-zа-яА-Я0-9]+)+)/ui, '<nobr>\1</nobr>') if @settings["dashglue"]
			end
			
			# Запятые и пробелы
			def process_spacing(text)
		      text.gsub!( /(\s*)([,]*)/sui, "\\2\\1");
		      text.gsub!( /(\s*)([\.?!]*)(\s*[ЁА-ЯA-Z])/su, "\\2\\1\\3");
			end
			
			# Неразрывные пробелы
			def process_nonbreakables(text)
		      text = " " + text + " ";
		      _text = " " + text + " ";
		      until _text == text
		         _text = text
		         text.gsub!( /(\s+)([a-zа-яА-Я]{1,2})(\s+)([^\\s$])/ui, '\1\2&nbsp;\4')
		         text.gsub!( /(\s+)([a-zа-яА-Я]{3})(\s+)([^\\s$])/ui,   '\1\2&nbsp;\4')
		      end

		      for i in @glueleft
		         text.gsub!( /(\s)(#{i})(\s+)/sui, '\1\2&nbsp;')
		      end

					for i in @glueright 
		         text.gsub!( /(\s)(#{i})(\s+)/sui, '&nbsp;\2\3')
					end
			end
						
			def process_inches(text)
				text.gsub!(/\s([0-9]{1,2}([\.,][0-9]{1,2})?)\"/ui, ' \1&quot;') if @settings["inches"]
			end
			
			# Обрабатывает знак +/-
			def process_plusmin(text)
			  text.gsub!(/\+\-/ui, "&#177;") if @settings["+-"]
			end
			
			# Обрабатывает телефоны
			def process_phones(text)
				@phonemasks[0].each_with_index do |regex, i|
	      	text.gsub!(regex, @phonemasks[1][i])
				end
			end
			
			# Обрабатывает знак градуса, набранный как caret
			def process_degrees(text)
		  	text.gsub!( /-([0-9])+\^([FCС])/, "&ndash;\\1&#176\\2")
		    text.gsub!( /\+([0-9])+\^([FCС])/, "+\\1&#176\\2")
		    text.gsub!( /\^([FCС])/, "&#176\\1")
			end
		end
	end
end