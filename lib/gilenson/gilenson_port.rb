module RuTils
  module Gilenson
  end
end

# Это - прямой порт Тыпографицы от pixelapes.
# Настройки можно регулировать через методы, т.е.
#
#   typ = RuTils::Gilenson::Obsolete.new('Эти "так называемые" великие деятели')
#   typ.html = false     => "false"
#   typ.dash = true      => "true"
#   typ.to_html => 'Эти &laquo;так называемые&raquo; великие деятели'
# Ни обновляться ни поддерживаться этот модуль более не будет.
class RuTils::Gilenson::Obsolete    
  def initialize(text, *args)
    @_text = text
    @skip_tags = true;
    @p_prefix = "<p class=typo>";
    @p_postfix = "</p>";
    @a_soft = true;
    @indent_a = "images/z.gif width=25 height=1 border=0 alt=\'\' align=top />" # <->
    @indent_b = "images/z.gif width=50 height=1 border=0 alt=\'\' align=top />" # <-->
    @fixed_size = 80  # максимальная ширина
    @ignore = /notypo/ # regex, который игнорируется. Этим надо воспользоваться для обработки pre и code

    @de_nobr = true;

    @phonemasks = [[  /([0-9]{4})\-([0-9]{2})\-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/,
                      /([0-9]{4})\-([0-9]{2})\-([0-9]{2})/,
                      /(\([0-9\+\-]+\)) ?([0-9]{3})\-([0-9]{2})\-([0-9]{2})/,
                      /(\([0-9\+\-]+\)) ?([0-9]{2})\-([0-9]{2})\-([0-9]{2})/,
                      /(\([0-9\+\-]+\)) ?([0-9]{3})\-([0-9]{2})/,
                      /(\([0-9\+\-]+\)) ?([0-9]{2})\-([0-9]{3})/,
                      /([0-9]{3})\-([0-9]{2})\-([0-9]{2})/,
                      /([0-9]{2})\-([0-9]{2})\-([0-9]{2})/,
                      /([0-9]{1})\-([0-9]{2})\-([0-9]{2})/,
                      /([0-9]{2})\-([0-9]{3})/,
                      /([0-9]+)\-([0-9]+)/,
                    ],[    
                     '<nobr>\1&ndash;\2&ndash;\3&nbsp;\4:\5:\6</nobr>',
                     '<nobr>\1&ndash;\2&ndash;\3</nobr>',
                     '<nobr>\1&nbsp;\2&ndash;\3&ndash;\4</nobr>',
                     '<nobr>\1&nbsp;\2&ndash;\3&ndash;\4</nobr>',
                     '<nobr>\1&nbsp;\2&ndash;\3</nobr>',
                     '<nobr>\1&nbsp;\2&ndash;\3</nobr>',
                     '<nobr>\1&ndash;\2&ndash;\3</nobr>',
                     '<nobr>\1&ndash;\2&ndash;\3</nobr>',
                     '<nobr>\1&ndash;\2&ndash;\3</nobr>',
                     '<nobr>\1&ndash;\2</nobr>',
                     '<nobr>\1&ndash;\2</nobr>'
                  ]]

    @glueleft =  ['рис.', 'табл.', 'см.', 'им.', 'ул.', 'пер.', 'кв.', 'офис', 'оф.', 'г.']
    @glueright = ['руб.', 'коп.', 'у.е.', 'мин.']

    @settings = {
                    "inches" => true, # преобразовывать дюймы в &quot;
                    "laquo" => true,  # кавычки-ёлочки
                    "farlaquo" => false,  # кавычки-ёлочки для фара (знаки "больше-меньше")
                    "quotes" => true, # кавычки-английские лапки
                    "dash" => true,   # короткое тире (150)
                    "emdash" => true, # длинное тире двумя минусами (151)
                    "(c)" => true, 
                    "(r)" => true,
                    "(tm)" => true,
                    "(p)" => true,
                    "+-" => true, # спецсимволы, какие - понятно
                    "degrees" => true, # знак градуса
                    "<-->" => true,    # отступы $Indent*
                    "dashglue" => true, "wordglue" => true, # приклеивание предлогов и дефисов
                    "spacing" => true, # запятые и пробелы, перестановка
                    "phones" => true,  # обработка телефонов
                    "fixed" => false,   # подгон под фиксированную ширину
                    "html" => false     # запрет тагов html
                 }
    # irrelevant - indentation with images
    @indent_a = "<!--indent-->"
    @indent_b = "<!--indent-->"
    
    @mark_tag = "\xF0\xF0\xF0\xF0" # Подстановочные маркеры тегов
    @mark_ignored = "\201" # Подстановочные маркеры неизменяемых групп
  end


  # Proxy unknown method calls as setting switches. Methods with = will set settings, methods without - fetch them
  def method_missing(meth, *args) #:nodoc:
    setting = meth.to_s.gsub(/=$/, '')
    super(meth, *args) unless @settings.has_key?(setting) #this will pop the exception if we have no such setting

    return @settings[meth.to_s] if setting == meth.to_s  
    return (@settings[meth.to_s] = args[0])
  end


  def to_html(no_paragraph = false)

    text = @_text
    
    # -2. игнорируем ещё регексп
    ignored = []


    text.scan(@ignore) do |result|
      ignored << result
    end

    text.gsub!(@ignore, @mark_ignored)  # маркер игнора

    # -1. запрет тагов html
    text.gsub!(/&/, '&amp;') if @settings["html"]


     # 0. Вырезаем таги
    #  проблема на самом деле в том, на что похожи таги.
    #   вариант 1, простой (закрывающий таг) </abcz>
    #   вариант 2, простой (просто таг)      <abcz>
    #   вариант 3, посложней                 <abcz href="abcz">
    #   вариант 4, простой (просто таг)      <abcz />
    #   вариант 5, вакка                     \xA2\xA2...== нафиг нафиг
    #   самый сложный вариант - это когда в параметре тага встречается вдруг символ ">"
    #   вот он: <abcz href="abcz>">
    #  как работает вырезание? введём спецсимвол. Да, да, спецсимвол.
    #    нам он ещё вопьётся =)
    #  заменим все таги на спец.символ, запоминая одновременно их в массив. 
    #  и будем верить, что спец.символы в дикой природе не встречаются.

    tags = []
    if (@skip_tags)
 #     re =  /<\/?[a-z0-9]+("+ # имя тага
 #                              "\s+("+ # повторяющая конструкция: хотя бы один разделитель и тельце
 #                                     "[a-z]+("+ # атрибут из букв, за которым может стоять знак равенства и потом
 #                                              "=((\'[^\']*\')|(\"[^\"]*\")|([0-9@\-_a-z:\/?&=\.]+))"+ # 
 #                                           ")?"+
 #                                  ")?"+
 #                            ")*\/?>|\xA2\xA2[^\n]*?==/i;

#          re =  /<\/?[a-z0-9]+(\s+([a-z]+(=((\'[^\']*\')|(\"[^\"]*\")|([0-9@\-_a-z:\/?&=\.]+)))?)?)*\/?>|\xA2\xA2[^\n]*?==/ui

      re =  /(<\/?[a-z0-9]+(\s+([a-z]+(=((\'[^\']*\')|(\"[^\"]*\")|([0-9@\-_a-z:\/?&=\.]+)))?)?)*\/?>)/ui

# по-хорошему атрибуты тоже нужно типографить. Или не нужно? бугага...

      tags = text.scan(re).map{|tag| tag[0] }
#            match = "&lt;" + match if @settings["html"]
      text.gsub!(re, @mark_tag) #маркер тега, мы используем Invalid UTF-sequence для него
  
#    puts "matched #{tags.size} tags"
    end

    # 1. Запятые и пробелы
    if @settings["spacing"]
      text.gsub!( /(\s*)([,]*)/sui, '\2\1');
      text.gsub!( /(\s*)([\.?!]*)(\s*[ЁА-ЯA-Z])/su, '\2\1\3');
    end

    # 2. Разбиение на строки длиной не более ХХ символов
    # --- для ваки не портировано ---
    # --- для ваки не портировано ---

    # 3. Спецсимволы
    # 0. дюймы с цифрами
    text.gsub!(/\s([0-9]{1,2}([\.,][0-9]{1,2})?)\"/ui, ' \1&quot;') if @settings["inches"]

    # 1. лапки
    if (@settings["quotes"])
      text.gsub!( /\"\"/ui, "&quot;&quot;")
      text.gsub!( /\"\.\"/ui, "&quot;.&quot;")
      _text = '""';
      while _text != text do  
        _text = text
        text.gsub!( /(^|\s|\201|\xF0\xF0\xF0\xF0|>)\"([0-9A-Za-z\'\!\s\.\?\,\-\&\;\:\_\xF0\xF0\xF0\xF0\201]+(\"|&#148;))/ui, '\1&#147;\2')
        #this doesnt work in-place. somehow.
        text = text.gsub( /(\&\#147\;([A-Za-z0-9\'\!\s\.\?\,\-\&\;\:\xF0\xF0\xF0\xF0\201\_]*).*[A-Za-z0-9][\xF0\xF0\xF0\xF0\201\?\.\!\,]*)\"/ui, '\1&#148;')
      end
    end

    # 2. ёлочки
    if @settings["laquo"]
      text.gsub!( /\"\"/ui, "&quot;&quot;");
      text.gsub!( /(^|\s|\201|\xF0\xF0\xF0\xF0|>|\()\"((\201|\xF0\xF0\xF0\xF0)*[~0-9ёЁA-Za-zА-Яа-я\-:\/\.])/ui, "\\1&laquo;\\2");
      # nb: wacko only regexp follows:
      text.gsub!( /(^|\s|\201|\xF0\xF0\xF0\xF0|>|\()\"((\201|\xF0\xF0\xF0\xF0|\/&nbsp;|\/|\!)*[~0-9ёЁA-Za-zА-Яа-я\-:\/\.])/ui, "\\1&laquo;\\2")
      _text = "\"\"";
      while (_text != text) do
        _text = text;
        text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\201|\xF0\xF0\xF0\xF0)*)\"/sui, "\\1&raquo;")
        # nb: wacko only regexps follows:
        text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\201|\xF0\xF0\xF0\xF0)*\?(\201|\xF0\xF0\xF0\xF0)*)\"/sui, "\\1&raquo;")
        text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\201|\xF0\xF0\xF0\xF0|\/|\!)*)\"/sui, "\\1&raquo;")
      end
    end


      # 2b. одновременно ёлочки и лапки
      if (@settings["quotes"] && (@settings["laquo"] or @settings["farlaquo"]))
        text.gsub!(/(\&\#147;\;(([A-Za-z0-9'!\.?,\-&;:]|\s|\xF0\xF0\xF0\xF0|\201)*)&laquo;(.*)&raquo;)&raquo;/ui,"\\1&#148;");
      end


      # 3. тире
      if (@settings["dash"])
        text.gsub!( /(\s|;)\-(\s)/ui, "\\1&ndash;\\2")
      end


      # 3a. тире длинное
      if (@settings["emdash"])
        text.gsub!( /(\s|;)\-\-(\s)/ui, "\\1&mdash;\\2")
        # 4. (с)
        text.gsub!(/\([сСcC]\)((?=\w)|(?=\s[0-9]+))/u, "&copy;") if @settings["(c)"]
        # 4a. (r)
        text.gsub!( /\(r\)/ui, "<sup>&#174;</sup>") if @settings["(r)"]

        # 4b. (tm)
        text.gsub!( /\(tm\)|\(тм\)/ui, "&#153;") if @settings["(tm)"]
        # 4c. (p)   
        text.gsub!( /\(p\)/ui, "&#167;") if @settings["(p)"]
      end


      # 5. +/-
      text.gsub!(/[^+]\+\-/ui, "&#177;") if @settings["+-"]


      # 5a. 12^C
      if @settings["degrees"]
        text.gsub!( /-([0-9])+\^([FCС])/, "&ndash;\\1&#176;\\2")
        text.gsub!( /\+([0-9])+\^([FCС])/, "+\\1&#176;\\2")
        text.gsub!( /\^([FCС])/, "&#176;\\1")
      end


       # 6. телефоны
      if @settings["phones"]
        @phonemasks[0].each_with_index do |v, i|
          text.gsub!(v, @phonemasks[1][i])
        end
      end


    # 7. Короткие слова и &nbsp;
    if (@settings["wordglue"])

      text = " " + text + " ";
      _text = " " + text + " ";
      until _text == text
         _text = text
         text.gsub!( /(\s+)([a-zа-яА-Я]{1,2})(\s+)([^\\s$])/ui, '\1\2&nbsp;\4')
         text.gsub!( /(\s+)([a-zа-яА-Я]{3})(\s+)([^\\s$])/ui,   '\1\2&nbsp;\4')
      end

      for i in @glueleft
         text.gsub!( /(\s)(#{i})(\s+)/sui, '\1\2&nbsp;')
      end

      for i in @glueright 
         text.gsub!( /(\s)(#{i})(\s+)/sui, '&nbsp;\2\3')
      end
    end



    # 8. Склейка ласт. Тьфу! дефисов.
    text.gsub!( /([a-zа-яА-Я0-9]+(\-[a-zа-яА-Я0-9]+)+)/ui, '<nobr>\1</nobr>') if @settings["dashglue"]


    # 9. Макросы



    # 10. Переводы строк
    # --- для ваки не портировано ---
    # --- для ваки не портировано ---


    # БЕСКОНЕЧНОСТЬ. Вставляем таги обратно.
  #  if (@skip_tags)
#    text = text.split("\xF0\xF0\xF0\xF0").join
#        

  tags.each do |tag|
    text.sub!(@mark_tag, tag)
  end

#        i = 0
#        text.gsub!(@mark_tag) {
#          i + 1
#          tags[i-1]
#        }

#      text = text.split("\xF0\xF0\xF0\xF0")
#puts "reinserted #{i} tags"
#
  #  end
    

#ext.gsub!("a", '')
#      raise "Text still has tag markers!" if text.include?("a")

    # БЕСКОНЕЧНОСТЬ-2. вставляем ещё сигнорированный регексп
    #
#      if @ignore
#        ignored.each { | tag | text.sub!(@mark_ignored, tag) }
#      end

#      raise "Text still has ignored markers!" if text.include?("\201")

    # БОНУС: прокручивание ссылок через A(...)
    # --- для ваки не портировано ---
    # --- для ваки не портировано ---

    # фуф, закончили.
 #   text.gsub!(/<nobr>/, "<span class=\"nobr\">").gsub(/<\/nobr>/, "</span>") if (@de_nobr)

#    text.gsub!(/<nobr>/, "<span class=\"nobr\">").gsub(/<\/nobr>/, "</span>") if (@de_nobr)

    text.gsub(/(\s)+$/, "").gsub(/^(\s)+/, "")

  end

end