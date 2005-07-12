module RuTils
	
	# Транслитерация позволяет вам обрабатывать текст транслитом или в транслите
	# "вот мы и здесь".translify => "vot my i zdes"
	# "vot my i zdes".detranslify => "вот мы и здесь"
	module Transliteration

		TABLE = {
			 "Ґ"=>"G","Ё"=>"YO","Є"=>"E","Ї"=>"YI","І"=>"I",
			 "і"=>"i","ґ"=>"g","ё"=>"yo","№"=>"#","є"=>"e",
			 "ї"=>"yi","А"=>"A","Б"=>"B","В"=>"V","Г"=>"G",
			 "Д"=>"D","Е"=>"E","Ж"=>"ZH","З"=>"Z","И"=>"I",
			 "Й"=>"Y","К"=>"K","Л"=>"L","М"=>"M","Н"=>"N",
			 "О"=>"O","П"=>"P","Р"=>"R","С"=>"S","Т"=>"T",
			 "У"=>"U","Ф"=>"F","Х"=>"H","Ц"=>"TS","Ч"=>"CH",
			 "Ш"=>"SH","Щ"=>"SCH","Ъ"=>"'","Ы"=>"YI","Ь"=>"",
			 "Э"=>"E","Ю"=>"YU","Я"=>"YA","а"=>"a","б"=>"b",
			 "в"=>"v","г"=>"g","д"=>"d","е"=>"e","ж"=>"zh",
			 "з"=>"z","и"=>"i","й"=>"y","к"=>"k","л"=>"l",
			 "м"=>"m","н"=>"n","о"=>"o","п"=>"p","р"=>"r",
			 "с"=>"s","т"=>"t","у"=>"u","ф"=>"f","х"=>"h",
			 "ц"=>"ts","ч"=>"ch","ш"=>"sh","щ"=>"sch","ъ"=>"'",
			 "ы"=>"yi","ь"=>"","э"=>"e","ю"=>"yu","я"=>"ya"
		}.sort do | one, two|
			two[1].size <=> one[1].size
		end
			
		# Заменяет кириллицу в строке на латиницу			
		def self.translify(str)
			s = str.clone
			TABLE.each do | translation |
				s = s.gsub(/#{translation[0]}/, translation[1])
			end
			s
		end
		
		# Заменяет латиницу на кириллицу			
		def self.detranslify(str)
			s = str.clone
			TABLE.each do | translation |
				s = s.gsub(/#{translation[1]}/, translation[0])
			end
			s
		end
		
		# Реализует транслитерацию любого объекта, реализующего String или to_s
		module StringFormatting
			
			#Транслитерирует строку в латиницу, и возвращает измененную строку
			def translify
				RuTils::Transliteration::translify(self.to_s)
			end

			#Транслитерирует строку, меняя объект	
			def translify!
				self.replace(self.translify)
			end
			
			# Транслитерирует строку, делая ее пригодной для применения как имя директории или URL
			def dirify
				st = self.translify
        st.gsub!(/(\s\&\s)|(\s\&amp\;\s)/, ' and ') # convert & to "and"
        st.gsub!(/\W/, ' ')  #replace non-chars
#        st.gsub!(/\ +/, '_') #replace spaces
        st.gsub!(/(_)$/, '') #trailing underscores
        st.gsub!(/^(_)/, '') #leading unders
				st.strip.translify.gsub(/(\s)/,'-').downcase.squeeze
			end
		end
		
	end
end

class String
	include RuTils::Transliteration::StringFormatting
end