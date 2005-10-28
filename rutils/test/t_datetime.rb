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
