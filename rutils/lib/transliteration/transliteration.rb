module RuTils
  module Transliteration #:nodoc:
  end
end

# Реализует простейшую транслитерацию
#   "вот мы и здесь".translify => "vot my i zdes"
#   "vot my i zdes".detranslify => "вот мы и здесь"
module RuTils::Transliteration::Simple
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
			s.gsub!(/#{translation[1]}/, translation[0])
		end
		s
	end

	# Транслитерирует строку, делая ее пригодной для применения как имя директории или URL
	def self.dirify(string)
		st = self.translify(string)
    st.gsub!(/(\s\&\s)|(\s\&amp\;\s)/, ' and ') # convert & to "and"
    st.gsub!(/\W/, ' ')  #replace non-chars
    st.gsub!(/(_)$/, '') #trailing underscores
    st.gsub!(/^(_)/, '') #leading unders
		st.strip.translify.gsub(/(\s)/,'-').downcase.squeeze
	end
end
		
# Реализует транслитерацию "в обе стороны", дающую возможность автоматически использовать URL как ключ записи
module RuTils::Transliteration::BiDi  #:nodoc:
	TABLE_TO = {
		"А"=>"A","Б"=>"B","В"=>"V","Г"=>"G","Д"=>"D",
		"Е"=>"E","Ё"=>"JO","Ж"=>"ZH","З"=>"Z","И"=>"I",
		"Й"=>"JJ","К"=>"K","Л"=>"L","М"=>"M","Н"=>"N",
		"О"=>"O","П"=>"P","Р"=>"R","С"=>"S","Т"=>"T",
		"У"=>"U","Ф"=>"F","Х"=>"KH","Ц"=>"C","Ч"=>"CH",
		"Ш"=>"SH","Щ"=>"SHH","Ъ"=>"_~","Ы"=>"Y","Ь"=>"_'",
		"Э"=>"EH","Ю"=>"JU","Я"=>"JA","а"=>"a","б"=>"b",
		"в"=>"v","г"=>"g","д"=>"d","е"=>"e","ё"=>"jo",
		"ж"=>"zh","з"=>"z","и"=>"i","й"=>"jj","к"=>"k",
		"л"=>"l","м"=>"m","н"=>"n","о"=>"o","п"=>"p",
		"р"=>"r","с"=>"s","т"=>"t","у"=>"u","ф"=>"f",
		"х"=>"kh","ц"=>"c","ч"=>"ch","ш"=>"sh","щ"=>"shh",
		"ъ"=>"~","ы"=>"y","ь"=>"'","э"=>"eh","ю"=>"ju",
		"я"=>"ja",
		# " "=>"__","_"=>"__"
		# так сразу не получится, будут проблемы с "Ь"=>"_'"
	}.sort do |one, two|
		two[1].jsize <=> one[1].jsize
	end

	TABLE_FROM = TABLE_TO.unshift([" ","__"]).clone
	TABLE_TO.unshift(["_","__"])

	def self.translify(str, allow_slashes = true)
		slash = allow_slashes ? '/' : '';

		s = str.clone.gsub(/[^\- _0-9a-zA-ZА-ёЁ#{slash}]/, '')
		lang_fr = s.scan(/[А-ёЁ ]+/)
		lang_fr.each do |fr|
			TABLE_TO.each do | translation |
				fr.gsub!(/#{translation[0]}/, translation[1])
			end
		end

		lang_sr = s.scan(/[0-9A-Za-z\_\-\.\/\']+/)

		string = ""
		if s =~ /\A[А-ёЁ ]/
			lang_fr, lang_sr = lang_sr, lang_fr
			string = "+"
		end

		0.upto([lang_fr.length, lang_sr.length].min-1) do |x|
			string += lang_sr[x] + "+" + lang_fr[x] + "+";
		end

		if (lang_fr.length < lang_sr.length)
			string += lang_sr[lang_sr.length-1]
		else
			string[0, string.length-1]
		end
	end

	def self.detranslify(str, allow_slashes = true)
		slash = allow_slashes ? '/' : '';

		str.split('/').inject(out = "") do |out, pg|
			strings = pg.split('+')
			1.step(strings.length-1, 2) do |x|
				TABLE_FROM.each do | translation |
					strings[x].gsub!(/#{translation[1]}/, translation[0])
				end
			end
			out << slash << strings.to_s
		end
		out[slash.length, out.length-slash.length]
	end
end

# Реализует транслитерацию любого объекта, реализующего String или to_s
module RuTils::Transliteration::StringFormatting
	
	#Транслитерирует строку в латиницу, и возвращает измененную строку
	def translify
		RuTils::Transliteration::Simple::translify(self.to_s)
	end

	#Транслитерирует строку, меняя объект	
	def translify!
		self.replace(self.translify)
	end
	
	# Транслитерирует строку, делая ее пригодной для применения как имя директории или URL
	def dirify
		RuTils::Transliteration::Simple::dirify(self.to_s)
	end
	
	# Транслитерирует строку (взаимно-однозначный транслит), и возвращает измененную строку
	def bidi_translify(allow_slashes = true) #:nodoc:
		RuTils::Transliteration::BiDi::translify(self.to_s, allow_slashes)
	end
	
	# Транслитерирует строку (взаимно-однозначный транслит), меняя объект
	def bidi_translify!(allow_slashes = true) #:nodoc:
		self.replace(RuTils::Transliteration::BiDi::translify(self.to_s, allow_slashes))
	end

	# Заменяет латиницу на кириллицу (взаимно-однозначный транслит), меняя объект
	def bidi_detranslify!(allow_slashes = true) #:nodoc:
		self.replace(RuTils::Transliteration::BiDi::detranslify(self.to_s, allow_slashes))
	end
	
	# Заменяет латиницу на кириллицу (взаимно-однозначный транслит), и возвращает измененную строку
	def bidi_detranslify(allow_slashes = true) #:nodoc:
		RuTils::Transliteration::BiDi::detranslify(self.to_s, allow_slashes)
	end
end

class Object::String
	include RuTils::Transliteration::StringFormatting
end