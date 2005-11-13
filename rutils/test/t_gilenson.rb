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
    assert_equal "Вот&#160;такие<tag some='foo>' />  <tagmore></tagmore> дела", "Вот такие<tag some='foo>' />  <tagmore></tagmore> дела".n_gilensize
  end
  
  def test_byte_pass
    assert_equal '<p>Теперь добираться до офиса Студии автортранспортом стало удобнее. ' +
                  'Для этого мы разместили в разделе <a href="#">«Контакт»</a> окно вебкамеры, ' +
                  'которая непрерывно транслирует дорожную обстановку на Садовом кольце по адресу Земляной Вал, 23. <br>' +
                  'Удачной дороги! </p>',
                  '<p>Теперь добираться до офиса Студии автортранспортом стало удобнее. ' +
                  'Для этого мы разместили в разделе <a href="#">«Контакт»</a> окно вебкамеры, ' +
                  'которая непрерывно транслирует дорожную обстановку на Садовом кольце по адресу Земляной Вал, 23. <br>' +
                  'Удачной дороги! </p>'.n_gilensize
  end

  def test_phones
    assert_equal '<nobr>3&#8211;12&#8211;30</nobr>', '3-12-30'.n_gilensize
    assert_equal '<nobr>12&#8211;34&#8211;56</nobr>', '12-34-56'.n_gilensize
    assert_equal '<nobr>88&#8211;25&#8211;04</nobr>', '88-25-04'.n_gilensize
    assert_equal '+7 <nobr>(99284)&#160;65&#8211;818</nobr>', '+7 (99284) 65-818'.n_gilensize
    assert_equal '<nobr>725&#8211;01&#8211;10</nobr>', '725-01-10'.n_gilensize
  end

  def test_address  
    assert_equal 'табл.&#160;2, рис.&#160;2.10', 'табл. 2, рис. 2.10'.n_gilensize
    assert_equal 'офис&#160;415, оф.340, д.5, ул.&#160;Народной Воли, пл. Малышева', 'офис 415, оф.340, д.5, ул. Народной Воли, пл. Малышева'.n_gilensize
  end

  def test_html_entities_replace
    assert_equal '&#34; &#38; &#39; &#62; &#60; &#160; &#167; &#169; &#171; &#174; &#176; &#177; &#183; &#187; &#8211; &#8212; &#8216; &#8217; &#8220; &#8221; &#8222; &#8226; &#8230; &#8482; &#8722;', '&quot; &amp; &apos; &gt; &lt; &nbsp; &sect; &copy; &laquo; &reg; &deg; &plusmn; &middot; &raquo; &ndash; &mdash; &lsquo; &rsquo; &ldquo; &rdquo; &bdquo; &bull; &hellip; &trade; &minus;'.n_gilensize
  end

  def test_ugly_entities_replace1 # not_correct_number
    assert_equal '&#8222; &#8230; &#39; &#8220; &#8221; &#8226; &#8211; &#8212; &#8482;', '&#132; &#133; &#146; &#147; &#148; &#149; &#150; &#151; &#153;'.n_gilensize
  end

  def test_specials
    assert_equal '&#169; 2002, &#169; 2003, &#169; 2004, &#169; 2005 &#8212; тоже без&#160;пробелов: &#169;2002, &#169;Кукуц. однако: варианты (а) и&#160;(с)', '(с) 2002, (С) 2003, (c) 2004, (C) 2005 -- тоже без пробелов: (с)2002, (c)Кукуц. однако: варианты (а) и (с)'.n_gilensize
    assert_equal '+5&#176;С, +7&#176;C, &#8211;5&#176;F', '+5^С, +17^C, -275^F'.n_gilensize
    assert_equal 'об&#160;этом подробнее &#8212; читай &#167;25', 'об этом подробнее -- читай (p)25'.n_gilensize
    assert_equal 'один же&#160;минус &#8211; краткое тире', 'один же минус - краткое тире'.n_gilensize
    assert_equal 'Sharpdesign&#8482;, Microsoft<sup>&#174;</sup>', 'Sharpdesign(tm), Microsoft(r)'.n_gilensize
  end

  def test_breaking
    assert_equal 'скажи, мне, ведь не&#160;даром! Москва, клеймённая пожаром. Французу отдана', 'скажи ,мне, ведь не даром !Москва, клеймённая пожаром .Французу отдана'.n_gilensize
    assert_equal 'so&#160;be it, my&#160;liege. Tiny dwellers roam thru midnight! Hell raised, the&#160;Balrog is&#160;hiding in&#160;your backyard!', 'so be it ,my liege .Tiny dwellers roam thru midnight !Hell raised, the Balrog is hiding in your backyard!'.n_gilensize
    assert_equal 'при&#160;установке командой строки в&#160;?page=help <nobr>бла-бла-бла-бла</nobr>', 'при установке командой строки в ?page=help бла-бла-бла-бла'.n_gilensize
    assert_equal 'как&#160;интересно будет переноситься со&#160;строки на&#160;строку <nobr>что-то</nobr> разделённое дефисом, ведь дефис тот&#160;тоже ведь из&#160;наших. <nobr>Какие-то</nobr> браузеры думают, что&#160;следует переносить и&#160;его...', 'как интересно будет переноситься со строки на строку что-то разделённое дефисом, ведь дефис тот тоже ведь из наших. Какие-то браузеры думают, что следует переносить и его...'.n_gilensize
  end

  def test_quotes  
    assert_equal 'english &#8220;quotes&#8221; should be&#160;quite like this', 'english "quotes" should be quite like this'.n_gilensize
    assert_equal 'русские же&#160;&#171;оформляются&#187; подобным образом', 'русские же "оформляются" подобным образом'.n_gilensize
    assert_equal 'кавычки &#171;расставлены&#187; &#8220;in a&#160;chaotic order&#8221;', 'кавычки "расставлены" "in a chaotic order"'.n_gilensize
    assert_equal 'диагональ моего монитора &#8212; 17&#8243;, а&#160;размер пениса &#8212; 1,5&#8243;', 'диагональ моего монитора -- 17", а размер пениса -- 1,5"'.n_gilensize
    assert_equal 'в&#160;толщину, &#171;вложенные &#8220;quotes&#8221; вот&#160;так&#187;, &#8220;or it&#160;&#171;будет вложено&#187; elsewhere&#8221;', 'в толщину, "вложенные "quotes" вот так", "or it "будет вложено" elsewhere"'.n_gilensize
    assert_equal '&#8220;complicated &#171;кавычки&#187;, &#171;странные &#8220;includements&#8221; кавычек&#187;', '"complicated "кавычки", "странные "includements" кавычек"'.n_gilensize
    assert_equal '&#8220;double &#8220;quotes&#8221;', '"double "quotes"'.n_gilensize
    assert_equal '&#171;дважды вложенные &#171;кавычки&#187;', '"дважды вложенные "кавычки"'.n_gilensize
    assert_equal '&#171;01/02/03&#187;, дискеты в&#160;5.25&#8243;', '"01/02/03", дискеты в 5.25"'.n_gilensize
    assert_equal 'после троеточия правая кавычка &#8212; &#171;Вот...&#187;', 'после троеточия правая кавычка -- "Вот..."'.n_gilensize
    assert_equal 'setlocale(LC_ALL, &#8220;ru_RU.UTF8&#8221;);', 'setlocale(LC_ALL, "ru_RU.UTF8");'.n_gilensize
    assert_equal '&#8220;read, write, delete&#8221; с&#160;флагом &#8220;only_mine&#8221;', '"read, write, delete" с флагом "only_mine"'.n_gilensize
    assert_equal '&#171;Двоеточие:&#187;, &#171;такую умную тему должен писать чувак умеющий скрипты скриптить.&#187;', '"Двоеточие:", "такую умную тему должен писать чувак умеющий скрипты скриптить."'.n_gilensize
    assert_equal '(&#171;Вики != HTML&#187; &#8212; &#171;Вики != HTML&#187; &#8212; (&#171;всякая чушь&#187;))', '("Вики != HTML" -- "Вики != HTML" -- ("всякая чушь"))'.n_gilensize
    assert_equal '&#171;фигня123&#187;, &#8220;fignya123&#8221;', '"фигня123", "fignya123"'.n_gilensize
#      assert_equal '&#171;сбалансированные &#171;кавычки<!--notypo--><!--/notypo--> (четыре в&#160;конце) &#8212; связано с&#160;синтаксисом ваки', '"сбалансированные "кавычки"""" (четыре в конце) -- связано с синтаксисом ваки'.n_gilensize
    assert_equal '&#171;несбалансированные &#171;кавычки&#34;&#34;" (три в&#160;конце) &#8212; связано с&#160;синтаксисом ваки', '"несбалансированные "кавычки""" (три в конце) -- связано с синтаксисом ваки'.n_gilensize
    assert_equal '&#171;разноязыкие quotes&#187;', '"разноязыкие quotes"'.n_gilensize
    assert_equal '&#171;multilanguage кавычки&#187;', '"multilanguage кавычки"'.n_gilensize
  end


  def test_initials
    assert_equal 'Это&#160;нам сказал П.И.&#8201;Петров', 'Это нам сказал П. И. Петров'.n_gilensize
  end
end


class GilensonConfigurationTest < Test::Unit::TestCase
  def setup
    @gilenson = RuTils::Gilenson::Formatter.new
  end
  
  def test_settings_as_tail_arguments

    assert_equal "Ну&#160;и куда вот&#160;&#8212; да&#160;туда!", 
      @gilenson.process("Ну и куда вот -- да туда!")

    assert_equal "Ну и куда вот &#8212; да туда!", 
      @gilenson.process("Ну и куда вот -- да туда!", :dash => false, :dashglue => false, :wordglue => false)

    assert_equal "Ну&#160;и куда вот&#160;&#8212; да&#160;туда!", 
      @gilenson.process("Ну и куда вот -- да туда!")
      
    @gilenson.configure!(:dash => false, :dashglue => false, :wordglue => false)

    assert_equal "Ну и куда вот &#8212; да туда!", 
      @gilenson.process("Ну и куда вот -- да туда!")    

    @gilenson.configure!(:all => true)

    assert_equal "Ну&#160;и куда вот&#160;&#8212; да&#160;туда!", 
      @gilenson.process("Ну и куда вот -- да туда!")

    @gilenson.configure!(:all => false)

    assert_equal "Ну и куда вот -- да туда!", 
      @gilenson.process("Ну и куда вот -- да туда!")
  end
  
  def test_glyph_override
    assert_equal 'скажи, мне, ведь не&#160;даром! Москва, клеймённая пожаром. Французу отдана',
      @gilenson.process('скажи ,мне, ведь не даром !Москва, клеймённая пожаром .Французу отдана')

    @gilenson.glyph[:nbsp] = '&nbsp;'
    assert_equal 'скажи, мне, ведь не&nbsp;даром! Москва, клеймённая пожаром. Французу отдана',
      @gilenson.process('скажи ,мне, ведь не даром !Москва, клеймённая пожаром .Французу отдана')
  end
  
  def test_ugly_entities_replace2 # copy&paste
    @gilenson.configure!(:copypaste => true)
    assert_equal '&#160; &#171; &#187; &#167; &#169; &#174; &#176; &#177; &#182; &#183; &#8211; &#8212; &#8216; &#8217; &#8220; &#8221; &#8222; &#8226; &#8230; &#8470; &#8482; &#8722; &#8201; &#8243;', @gilenson.process('  « » § © ® ° ± ¶ · – — ‘ ’ “ ” „ • … № ™ −   ″')
  end
  
  def test_raise_on_unknown_setting
    assert_raise(RuTils::Gilenson::UnknownSetting) { @gilenson.configure!(:bararara => true) }
  end
  
  def test_raw_utf8_output
    @gilenson.configure!(:raw_output=>true)
    assert_equal '&#38442; Это просто «кавычки»',
      @gilenson.process('&#38442; Это просто "кавычки"')    
  end
  
  def test_configure_alternate_names
    assert @gilenson.configure(:raw_output=>true)    
    assert @gilenson.configure!(:raw_output=>true)    
  end

  def test_skip_code
    @gilenson.configure!(:all => true)
    
    @gilenson.configure!(:skip_code => true)
    
    assert_equal "<code>Скип -- скип!</code>",
      @gilenson.process("<code>Скип -- скип!</code>")
    
    assert_equal '<code attr="test -- attr">Скип -- скип!</code>',
      @gilenson.process('<code attr="test -- attr">Скип -- скип!</code>')
    
    assert_equal "<tt>Скип -- скип!</tt> test &#8212; test <tt attr='test -- attr'>Скип -- скип!</tt>",
      @gilenson.process("<tt>Скип -- скип!</tt> test -- test <tt attr='test -- attr'>Скип -- скип!</tt>")
    
    assert_equal "<TT>Скип -- скип!</TT><TT>Скип -- скип!</TT> &#8212; <CoDe attr='test -- attr'>Скип -- скип!</cOdE>",
      @gilenson.process("<TT>Скип -- скип!</TT><TT>Скип -- скип!</TT> -- <CoDe attr='test -- attr'>Скип -- скип!</cOdE>")
    
    assert_equal "<ttt>Скип &#8212; скип!</tt>",
      @gilenson.process("<ttt>Скип -- скип!</tt>")
    
    assert_equal "<tt>Скип &#8212; скип!</ttt>",
      @gilenson.process("<tt>Скип -- скип!</ttt>")
    
    assert_equal "Ах, &#8212; <code>var x = j // -- тест</code>",
      @gilenson.process("Ах, -- <code>var x = j // -- тест</code>")
    
    assert_equal "<![CDATA[ CDATA -- ]]> &#8212; CDATA",
      @gilenson.process("<![CDATA[ CDATA -- ]]> -- CDATA")
    
    assert_equal "<![CDATA[ CDATA -- >] -- CDATA ]]> &#8212; <![CDATA[ CDATA ]> -- CDATA ]]>",
      @gilenson.process("<![CDATA[ CDATA -- >] -- CDATA ]]> -- <![CDATA[ CDATA ]> -- CDATA ]]>")
    
    assert_equal "<![CDATA[ CDATA -- >] -- CDATA ]]> &#8212; <![CDATA[ CDATA ]> -- CDATA ]]>  &#8212; CDATA ]]>",
      @gilenson.process("<![CDATA[ CDATA -- >] -- CDATA ]]> -- <![CDATA[ CDATA ]> -- CDATA ]]>  -- CDATA ]]>")
    
    @gilenson.configure!(:skip_code => false)
    
    assert_equal "Ах, &#8212; <code>var x&#160;= j&#160;// &#8212; тест</code>",
      @gilenson.process("Ах, -- <code>var x = j // -- тест</code>")
  end

  def test_skip_attr
    @gilenson.configure!(:skip_attr => true)
    
    assert_equal "<a href='#' title='test -- me'>just &#8212; test</a>",
      @gilenson.process("<a href='#' title='test -- me'>just -- test</a>")
    
    assert_equal 'мы&#160;напишем title="test &#8212; me" и&#160;alt=\'test &#8212; me\', вот',
      @gilenson.process('мы напишем title="test -- me" и alt=\'test -- me\', вот')
    
    @gilenson.configure!(:skip_attr => false)
    
    assert_equal "<a href='#' title='test &#8212; me'>just &#8212; test</a>",
      @gilenson.process("<a href='#' title='test -- me'>just -- test</a>")
    
    assert_equal 'мы&#160;напишем title="test &#8212; me" и&#160;alt=\'test &#8212; me\', вот',
      @gilenson.process('мы напишем title="test -- me" и alt=\'test -- me\', вот')
  end

  def test_apmersand_in_tags
    @gilenson.configure!(:raw_output=>true)
    
    assert_equal "<a href='test?test1=1&test2=2'>test</a>",
      @gilenson.process("<a href='test?test1=1&test2=2'>test</a>")
    
    @gilenson.configure!(:raw_output=>false)
    
    assert_equal "<a href='test?test1=1&#38;test2=2'>test</a>",
      @gilenson.process("<a href='test?test1=1&#38;test2=2'>test</a>")
    
    assert_equal "<a href='test?test1=1&#038;test2=2'>test</a>",
      @gilenson.process("<a href='test?test1=1&#038;test2=2'>test</a>")
    
    assert_equal "<a href='test?test1=1&#38;test2=2'>test</a>",
      @gilenson.process("<a href='test?test1=1&amp;test2=2'>test</a>")
    
  end

end

# class TypograficaTrakoEntries < Test::Unit::TestCase
#     def test_cpp
#       assert_equal "C++-API", "C++-API".gilensize
#     end
#     
#     def test_symmetricity # http://pixel-apes.com/typografica/trako/12
#       assert_equal "&#171;Справка&#160;09&#187;", '"Справка 09"'.gilensize
#     end
#     
#     def test_paths # http://pixel-apes.com/typografica/trako/13
#       assert_equal '&#171;c:\www\sites\&#187;', '"c:\www\sites\"'.gilensize
#     end
# end