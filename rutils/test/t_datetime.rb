$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'

class DistanceOfTimeTest < Test::Unit::TestCase
	def test_distance_of_time_in_words
		assert_equal "меньше минуты", RuTils::DateTime::distance_of_time_in_words(0, 50)
		assert_equal "2 минуты", RuTils::DateTime::distance_of_time_in_words(0, 140)
		assert_equal "около 2 часов", RuTils::DateTime::distance_of_time_in_words(0, 60*114)
		assert_equal "около 3 часов", RuTils::DateTime::distance_of_time_in_words(0, 60*120+60*60)
	end
end

class StrftimeRuTest < Test::Unit::TestCase
	def test_strftime_ru
		assert_equal "Суббота, тридцатьпервое декабря 2005 года", Time.local(2005,"dec",31).strftime_ru("%A, %E %Y года")
		assert_equal "Среда, тридцатое ноября 2005 года", Time.local(2005,"nov",30).strftime_ru("%A, %E %Y года")
		assert_equal "Вторник, двадцатьдевятое ноября 2005 года", Time.local(2005,"nov",29).strftime_ru("%A, %E %Y года")
		assert_equal "Понедельник, двадцатьпервое ноября 2005 года", Time.local(2005,11,21).strftime_ru("%A, %E %Y года")
		assert_equal "Воскресенье, двадцатое ноября 2005 года", Time.local(2005,11,20).strftime_ru("%A, %E %Y года")
		assert_equal "Суббота, девятнадцатое ноября 2005 года", Time.local(2005,11,19).strftime_ru("%A, %E %Y года")
		assert_equal "Пятница, одиннадцатое ноября 2005 года", Time.local(2005,11,11).strftime_ru("%A, %E %Y года")
		assert_equal "Вторник, первое ноября 2005 года", Time.local(2005,11,1).strftime_ru("%A, %E %Y года")
		assert_equal "Воскресенье, первое января 2006 года", Time.local(2006,1,1).strftime_ru("%A, %E %Y года")
		assert_equal "Вск Воскресенье Янв Январь первое января 1", Time.local(2006,1,1).strftime_ru("%a %A %b %B %E %e")
		assert_equal "Сб Суббота Дек Декабрь тридцатьпервое декабря 31", Time.local(2005,12,31).strftime_ru("%a %A %b %B %E %e")
		assert_equal "31.12.2005", Time.local(2005,12,31).strftime_ru
	end
end
