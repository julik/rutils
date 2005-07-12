$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'


# Cюда идут наши тесты типографа. Мы содержим их отдельно поскольку набор тестов Типографицы нами не контролируется.
# Когда у рутилей появятся собственные баги под каждый баг следует завести тест
class GilensonOwnTest < Test::Unit::TestCase
	
	# Проверка изъятия тагов и помещения их На Место©
	# характерно что пока мы не рефакторнули все как следует можно проверять
	# только конечный результат трансформации - что глючно до безобразия
	def test_tag_lift
		assert_equal "Вот&nbsp;такие<tag some='foo>' />  <tagmore></tagmore> дела", "Вот такие<tag some='foo>' />  <tagmore></tagmore> дела".gilensize
	end
	
	def test_byte_pass
		assert_equal '<p>Теперь добираться до офиса Студии автортранспортом стало удобнее. ' +
									'Для этого мы разместили в разделе <a href="#">«Контакт»</a> окно вебкамеры, ' +
									'которая непрерывно транслирует дорожную обстановку на Садовом кольце по адресу Земляной Вал, 23. <br>' +
    							'Удачной дороги! </p>',
			'<p>Теперь добираться до офиса Студии автортранспортом стало удобнее. ' + 
			'Для этого мы разместили в разделе <a href="#">«Контакт»</a> окно вебкамеры, ' +
			'которая непрерывно транслирует дорожную обстановку на Садовом кольце по адресу Земляной Вал, 23. <br>' +
     'Удачной дороги! </p>'.gilensize
	end

end

# class TypograficaTrakoEntries < Test::Unit::TestCase
# 		def test_cpp
# 			assert_equal "C++-API", "C++-API".gilensize
# 		end
# 		
# 		def test_symmetricity # http://pixel-apes.com/typografica/trako/12
# 			assert_equal "&laquo;Справка&nbsp;09&raquo;", '"Справка 09"'.gilensize
# 		end
# 		
# 		def test_paths # http://pixel-apes.com/typografica/trako/13
# 			assert_equal "&laquo;c:\www\sites\&raquo;", '"c:\www\sites\"'.gilensize
# 		end
# end