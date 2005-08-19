$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'

class DistanceOfTimeTest < Test::Unit::TestCase
	def test_distance_of_time_in_words
		assert_equal "меньше минуты", RuTils::DateTime::distance_of_time_in_words(0, 50)
		assert_equal "две минуты", RuTils::DateTime::distance_of_time_in_words(0, 140)
	end
end
