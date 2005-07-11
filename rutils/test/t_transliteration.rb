$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'


class TranslitTest < Test::Unit::TestCase
			
  def setup
    @string = "Это кусок строки русских букв v peremshku s latinizey i ampersandom (pozor!) & something"
  end

	def test_translify
		assert_equal "sch", 'щ'.translify
		assert_equal "upuschenie", 'упущение'.translify
		assert_equal "sh", 'ш'.translify
		assert_equal "ts", 'ц'.translify
		assert_equal "Eto kusok stroki russkih bukv v peremshku s latinizey i ampersandom (pozor!) & something", @string.translify
		assert_equal "Это просто некий текст".translify, "Eto prosto nekiy tekst"
	end

	def test_dirify
		assert_equal "eto-kusok-stroki-ruskih-bukv-v-peremshku-s-latinizey-i-ampersandom-(pozor!)-&-something", @string.dirify
		assert_equal "esche-ruskiy-tekst", "Еще РусСКий теКст".dirify
	end	
end