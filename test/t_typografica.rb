$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'

# Тесты Гиленсона - обычный набор тестов к Тыпографице с сайта pixel-apes. Все "наши" тесты Гиленсона идут в другой test case!
class TypograficaComplianceTest < Test::Unit::TestCase
  
  def test_phones
    assert_equal '<nobr>3&ndash;12&ndash;30</nobr>', '3-12-30'.o_gilensize
    assert_equal '<nobr>12&ndash;34&ndash;56</nobr>', '12-34-56'.o_gilensize
    assert_equal '<nobr>88&ndash;25&ndash;04</nobr>', '88-25-04'.o_gilensize
    assert_equal '+7 <nobr>(99284)&nbsp;65&ndash;818</nobr>', '+7 (99284) 65-818'.o_gilensize
    assert_equal '<nobr>725&ndash;01&ndash;10</nobr>', '725-01-10'.o_gilensize
  end

  def test_address  
    assert_equal 'табл.&nbsp;2, рис.&nbsp;2.10', 'табл. 2, рис. 2.10'.o_gilensize
    assert_equal 'офис&nbsp;415, оф.340, д.5, ул.&nbsp;Народной Воли, пл. Малышева', 'офис 415, оф.340, д.5, ул. Народной Воли, пл. Малышева'.o_gilensize
  end

  def test_specials
    assert_equal '&copy; 2002, &copy; 2003, &copy; 2004, &copy; 2005 &mdash; тоже без&nbsp;пробелов: &copy;2002, &copy;Кукуц. однако: варианты (а) и&nbsp;(с)', '(с) 2002, (С) 2003, (c) 2004, (C) 2005 -- тоже без пробелов: (с)2002, (c)Кукуц. однако: варианты (а) и (с)'.o_gilensize
    assert_equal '+5&#176;С, +7&#176;C, &ndash;5&#176;F', '+5^С, +17^C, -275^F'.o_gilensize
    assert_equal 'об&nbsp;этом подробнее &mdash; читай &#167;25', 'об этом подробнее -- читай (p)25'.o_gilensize
    assert_equal 'один же&nbsp;минус &ndash; краткое тире', 'один же минус - краткое тире'.o_gilensize
    assert_equal 'Sharpdesign&#153;, Microsoft<sup>&#174;</sup>', 'Sharpdesign(tm), Microsoft(r)'.o_gilensize
  end

  def test_breaking
    assert_equal 'скажи, мне, ведь не&nbsp;даром! Москва, клеймённая пожаром. Французу отдана', 'скажи ,мне, ведь не даром !Москва, клеймённая пожаром .Французу отдана'.o_gilensize
    assert_equal 'so&nbsp;be it, my&nbsp;liege. Tiny dwellers roam thru midnight! Hell raised, the&nbsp;Balrog is&nbsp;hiding in&nbsp;your backyard!', 'so be it ,my liege .Tiny dwellers roam thru midnight !Hell raised, the Balrog is hiding in your backyard!'.o_gilensize
    assert_equal 'при&nbsp;установке командой строки в&nbsp;?page=help <nobr>бла-бла-бла-бла</nobr>', 'при установке командой строки в ?page=help бла-бла-бла-бла'.o_gilensize
    assert_equal 'как&nbsp;интересно будет переноситься со&nbsp;строки на&nbsp;строку <nobr>что-то</nobr> разделённое дефисом, ведь дефис тот&nbsp;тоже ведь из&nbsp;наших. <nobr>Какие-то</nobr> браузеры думают, что&nbsp;следует переносить и&nbsp;его...', 'как интересно будет переноситься со строки на строку что-то разделённое дефисом, ведь дефис тот тоже ведь из наших. Какие-то браузеры думают, что следует переносить и его...'.o_gilensize
  end

  def test_quotes  
    assert_equal 'english &#147;quotes&#148; should be&nbsp;quite like this', 'english "quotes" should be quite like this'.o_gilensize
    assert_equal 'русские же&nbsp;&laquo;оформляются&raquo; подобным образом', 'русские же "оформляются" подобным образом'.o_gilensize
    assert_equal 'кавычки &laquo;расставлены&raquo; &#147;in a&nbsp;chaotic order&#148;', 'кавычки "расставлены" "in a chaotic order"'.o_gilensize
    assert_equal 'диагональ моего монитора &mdash; 17&quot;, а&nbsp;размер пениса &mdash; 1,5&quot;', 'диагональ моего монитора -- 17", а размер пениса -- 1,5"'.o_gilensize
    assert_equal 'в&nbsp;толщину, &laquo;вложенные &#147;quotes&#148; вот&nbsp;так&raquo;, &#147;or it&nbsp;&laquo;будет вложено&raquo; elsewhere&#148;', 'в толщину, "вложенные "quotes" вот так", "or it "будет вложено" elsewhere"'.o_gilensize
    assert_equal '&#147;complicated &laquo;кавычки&raquo;, &laquo;странные &#147;includements&#148; кавычек&raquo;', '"complicated "кавычки", "странные "includements" кавычек"'.o_gilensize
    assert_equal '&#147;double &#147;quotes&#148;', '"double "quotes"'.o_gilensize
    assert_equal '&laquo;дважды вложенные &laquo;кавычки&raquo;', '"дважды вложенные "кавычки"'.o_gilensize
    assert_equal '&laquo;01/02/03&raquo;, дискеты в&nbsp;5.25&quot;', '"01/02/03", дискеты в 5.25"'.o_gilensize
    assert_equal 'после троеточия правая кавычка &mdash; &laquo;Вот...&raquo;', 'после троеточия правая кавычка -- "Вот..."'.o_gilensize
    assert_equal 'setlocale(LC_ALL, &#147;ru_RU.UTF8&#148;);', 'setlocale(LC_ALL, "ru_RU.UTF8");'.o_gilensize
    assert_equal '&#147;read, write, delete&#148; с&nbsp;флагом &#147;only_mine&#148;', '"read, write, delete" с флагом "only_mine"'.o_gilensize
    assert_equal '&laquo;Двоеточие:&raquo;, &laquo;такую умную тему должен писать чувак умеющий скрипты скриптить.&raquo;', '"Двоеточие:", "такую умную тему должен писать чувак умеющий скрипты скриптить."'.o_gilensize
    assert_equal '(&laquo;Вики != HTML&raquo; &mdash; &laquo;Вики != HTML&raquo; &mdash; (&laquo;всякая чушь&raquo;))', '("Вики != HTML" -- "Вики != HTML" -- ("всякая чушь"))'.o_gilensize
    assert_equal '&laquo;фигня123&raquo;, &#147;fignya123&#148;', '"фигня123", "fignya123"'.o_gilensize
#      assert_equal '&laquo;сбалансированные &laquo;кавычки<!--notypo--><!--/notypo--> (четыре в&nbsp;конце) &mdash; связано с&nbsp;синтаксисом ваки', '"сбалансированные "кавычки"""" (четыре в конце) -- связано с синтаксисом ваки'.o_gilensize
    assert_equal '&laquo;несбалансированные &laquo;кавычки&quot;&quot;" (три в&nbsp;конце) &mdash; связано с&nbsp;синтаксисом ваки', '"несбалансированные "кавычки""" (три в конце) -- связано с синтаксисом ваки'.o_gilensize
    assert_equal '&laquo;разноязыкие quotes&raquo;', '"разноязыкие quotes"'.o_gilensize
    assert_equal '&laquo;multilanguage кавычки&raquo;', '"multilanguage кавычки"'.o_gilensize
  end
end