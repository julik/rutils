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
		if RuTils::overrides_enabled?
			assert_equal "Сб, Суббота, Дек, Декабрь", Time.local(2005,"dec",31).strftime("%a, %A, %b, %B")
			assert_equal "%a, %A, %b, %B", Time.local(2005,"dec",31).strftime("%%a, %%A, %%b, %%B")
			assert_equal "%Сб, %Суббота, %Дек, %Декабрь", Time.local(2005,"dec",31).strftime("%%%a, %%%A, %%%b, %%%B")
			assert_equal "Сегодня: 31 Декабрь, Суббота, 2005 год", Time.local(2005,"dec",31).strftime("Сегодня: %d Декабрь, %A, %Y год")
			
			date = Date.new(2005, 11, 9)
			assert_equal "Ноя Ноябрь Ср Среда", "#{Date::RU_ABBR_MONTHNAMES[date.mon]} #{Date::RU_MONTHNAMES[date.mon]} #{Date::RU_ABBR_DAYNAMES[date.wday]} #{Date::RU_DAYNAMES[date.wday]}"
		end #RuTils::overrides_enabled?
	end
end
