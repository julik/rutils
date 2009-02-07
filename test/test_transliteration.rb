# -*- encoding: utf-8 -*- 
$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'


class TranslitTest < Test::Unit::TestCase

  def setup
    @string = "Это кусок строки русских букв v peremeshku s latinizey i амперсандом (pozor!) & something"
  end

  def test_translify
    assert_equal "sch", 'щ'.translify
    assert_equal "stansyi", "стансы".translify
    assert_equal "upuschenie", 'упущение'.translify    
    assert_equal "sh", 'ш'.translify
    assert_equal "SH", 'Ш'.translify
    assert_equal "ts", 'ц'.translify
    assert_equal "Eto kusok stroki russkih bukv v peremeshku s latinizey i ampersandom (pozor!) & something", @string.translify
    assert_equal "Это просто некий текст".translify, "Eto prosto nekiy tekst"

    assert_equal "NEVEROYATNOE UPUSCHENIE", 'НЕВЕРОЯТНОЕ УПУЩЕНИЕ'.translify
    assert_equal "Neveroyatnoe Upuschenie", 'Невероятное Упущение'.translify
    assert_equal "Sherstyanoy Zayats", 'Шерстяной Заяц'.translify
    assert_equal "N.P. Sherstyakov", 'Н.П. Шерстяков'.translify
    assert_equal "SHAROVARYI", 'ШАРОВАРЫ'.translify
  end
  
# def test_detranslify
#   puts "Шерстяной негодяй"
#   assert_equal "щ", "sch".detranslify
#   assert_equal "Щ", "SCH".detranslify
#   assert_equal "Щ", "Sch".detranslify
#   assert_equal "Щукин", "Schukin".detranslify
#   assert_equal "Шерстяной негодяй", "Scherstyanoy negodyay".detranslify
# end

  def test_dirify
    assert_equal "eto-kusok-stroki-russkih-bukv-v-peremeshku-s-latinizey-i-ampersandom-pozor-and-something", @string.dirify
    assert_equal "esche-russkiy-tekst", "Еще РусСКий теКст".dirify
    assert_equal "kooperator-poobedal-offlayn", "кооператор  пообедал  оффлайн".dirify, "dirify не должен съедать парные буквы"
  end  
end


class BiDiTranslitTest < Test::Unit::TestCase

  def test_bidi_translify_raises_unsupported
    assert_raise(RuTils::RemovedFeature) { "xxx".bidi_translify }
    assert_raise(RuTils::RemovedFeature) { "xxx".bidi_detranslify }
  end
end