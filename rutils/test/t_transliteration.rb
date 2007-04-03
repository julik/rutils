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
    # dirify не должен съедать парные буквы
    assert_equal "kooperator-poobedal-offlayn", "кооператор  пообедал  оффлайн".dirify
  end  
end


class BiDiTranslitTest < Test::Unit::TestCase

  def setup
  @strings_all_with_slash = {
  "ThisIsРусскийName/ДляВас/ДемонстрацияOfSwitching" => "ThisIs+Russkijj+Name/+DljaVas+/+Demonstracija+OfSwitching",
  "Андрэ Нортон Зачумлённый корабльzip" => "+Andreh__Norton__Zachumljonnyjj__korabl'+zip",
  "Эй Эгегей" => "+EHjj__EHgegejj",
  "эй-эй" => "+ehjj+-+ehjj",
  "WebРазработка/Скрипты" => "Web+Razrabotka+/+Skripty",
  "Смотрите зайцы -- нас много" => "+Smotrite__zajjcy__+--+__nas__mnogo",
  "Привет Родина" => "+Privet__Rodina",
  "ЙухХа" => "+JJukhKHa",
  "Ыхыхых Its English text" => "+Ykhykhykh__+Its+__+English+__+text",
  "Пьянь" => "+P'jan'",
  "----____" => "----____",
  "Madonna - Свежия Песенки" => "Madonna+__+-+__Svezhija__Pesenki",
  "58-49" => "58-49",
  "Въезд ГЛЯНЬ ВЪЕЗД" => "+V~ezd__GLJAN_'__V_~EZD",
  "----____" => "----____",
  "Въезд ГЛЯНь ВЪЕЗД" => "+V~ezd__GLJAN'__V_~EZD",
  "Установка mod_perl" => "+Ustanovka__+mod_perl",
  "Проверка__двери неразумной" => "+Proverka+__+dveri__nerazumnojj",
  "Проверка_ дверцы" => "+Proverka+_+__dvercy",
  "Кровать устала _ь" => "+Krovat'__ustala__+_+'",
  "test__bed" => "test__bed",
  "test_ bed" => "test_+__+bed",
  "test__ __bed" => "test__+__+__bed",
  "a_-_b-_-c" => "a_-_b-_-c",
  "a - b _ c" => "a+__+-+__+b+__+_+__+c",
  }
  
  @strings_tran_without_slash = {
  "Андрэ/ Н/о/ртон /Зачум//лённый корабль/z/ip" => "+Andreh__Norton__Zachumljonnyjj__korabl'+zip",
  "WebРазработка/Мимо" => "Web+RazrabotkaMimo",
  "test_/_bed" => "test__bed",
  }
  
  @strings_detran_without_slash = {
  "Webds" => "/We/bds/",
  "WebРазработкаМимо" => "Web/+Razrabotka+/+Mimo",
  "WebСкрипты" => "Web/+Skripty",
  "ПХПScripts" => "+PKHP+/Scripts",
  }
  end

  def test_bidi_translify
    @strings_all_with_slash.each do |strFrom, strTo|
      assert_equal strTo, strFrom.bidi_translify
    end
    @strings_tran_without_slash.each do |strFrom, strTo|
      assert_equal strTo, strFrom.bidi_translify(false)
    end
  end

  def test_bidi_detranslify
    @strings_all_with_slash.each do |strTo, strFrom|
      assert_equal strTo, strFrom.bidi_detranslify
    end
    @strings_detran_without_slash.each do |strTo, strFrom|
      assert_equal strTo, strFrom.bidi_detranslify(false)
    end
  end
end