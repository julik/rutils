class RuTils::Gilenson::New < String #:nodoc:

  def initialize(*args)
    # Задача (вкратце) состоит в том чтобы все ступени разработки развести в отдельные методы
    # и тестировать их отдельно друг от друга (а также иметь возможность их по-одному включать и выключать).
    # Фильтры, которые начинаются с lift работают с блоком (например - вытащить таги, провести обработку
    # текста и вернуть все назад)
        
    # Фильтры обрабатываются именно в таком порядке. Этот массив стравнивается с настройками, и если настройки
    # для конкретного фильтра установлены в false этот фильтр обработан не будет.
    # Каждый фильтр должен именоваться process_{filter}, принимать аргументом текст для обработки и возвращать его же!
    # После того как фильтр включен в массив order_of_filters и для него написан метод фильтр по лумолчанию включается,
    # и его настройку можно поменять с помощью аксессора с соотв. именем. Это делается автоматом.
    # Главный обработчик должен сам понимать, использовать ли блок (если метод-делегат начинается с lift_)
    # или просто process.
  
    # Аксессор само собой генерируется автоматом.
  
    @@order_of_filters = [
        :inches,
        :dashes,
        :emdashes,
        :specials,
        :spacing,
        :dashglue,
        :nonbreakables,
        :plusmin,
        :degrees,
        :phones,
        :simple_quotes,
        :typographer_quotes,
        :compound_quotes,
    ] 
  
    # Символы, используемые в подстановках. Меняются через substitute_set(subst_name, subst_content)
    # Нужно потому как ващето &nbsp; недопустим в XML, равно как и всякие mdash.
    @@spec_chars = {
      :laquo=>'&laquo;', #left acute
      :raquo=>'&raquo;', #right acute
      :ndash=>'&ndash;', #en dash
      :mdash=>'&mdash;', #en dash
      :inch=>'&quot;', #en dash
      :nbsp=>'&nbsp;', #non-breakable
    }   

    @@phonemasks = [[ /([0-9]{4})\-([0-9]{2})\-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/,
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
                
    @@glueleft =  ['рис.', 'табл.', 'см.', 'им.', 'ул.', 'пер.', 'кв.', 'офис', 'оф.', 'г.']
    @@glueright = ['руб.', 'коп.', 'у.е.', 'мин.']

    @@settings = {
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
    @@indent_a = "<!--indent-->"
    @@indent_b = "<!--indent-->"
  
    @@mark_tag = "\xF0\xF0\xF0\xF0" # Подстановочные маркеры тегов - BOM
    @@mark_ignored = "\xFF\xFF\xFF\xFF" # Подстановочные маркеры неизменяемых групп - BOM+ =)
  
    @@ignore = /notypo/ # regex, который игнорируется. Этим надо воспользоваться для обработки pre и code

    self.methods.each do | m |
      next unless m.include?("process_")
      raise NoMethodError, "No hook for " + m unless @@order_of_filters.include?(m.gsub(/process_/, '').to_sym)
    end
  
    @@order_of_filters.each do |filter|
      raise NoMethodError, "No process method for " + filter unless self.methods.include?("process_#{filter}".to_sym)
    end

    super(*args)

  end

  
  def to_html(*opts)
    text = self.to_s.clone
    lift_tags(text) do | text |
#         lift_ignored(text) do |text|
        for filter in @@order_of_filters
          raise "UnknownFilter #process_#{filter} in filterlist!" unless self.respond_to?("process_#{filter}".to_sym)
          self.send("process_#{filter}".to_sym, text) # if @settings[filter.to_sym] # вызываем конкретный фильтр
        end
#         end
    end
    text
  end
    
  # Вытаскивает теги из текста, выполняет переданный блок и возвращает теги на место.
  # Теги в процессе заменяются на специальный маркер      
  def lift_tags(text, marker="\xF0\xF0\xF0\xF0", &block)
    
   # Выцепляем таги
   #  re =  /<\/?[a-z0-9]+("+ # имя тага
   #                              "\s+("+ # повторяющая конструкция: хотя бы один разделитель и тельце
   #                                     "[a-z]+("+ # атрибут из букв, за которым может стоять знак равенства и потом
   #                                              "=((\'[^\']*\')|(\"[^\"]*\")|([0-9@\-_a-z:\/?&=\.]+))"+ # 
   #                                           ")?"+
   #                                  ")?"+
   #                            ")*\/?>|\xA2\xA2[^\n]*?==/i;

    re =  /(<\/?[a-z0-9]+(\s+([a-z]+(=((\'[^\']*\')|(\"[^\"]*\")|([0-9@\-_a-z:\/?&=\.]+)))?)?)*\/?>)/ui
    
    tags = text.scan(re).inject([]) { | ar, match | ar << match[0] }
    text.gsub!(re, "\xF0\xF0\xF0\xF0") #маркер тега
    
    yield(text, marker) if block_given? #делаем все что надо сделать без тегов
    
    tags.each { | tag | text.sub!(marker, tag) }  # Вставляем таги обратно.

  end

  # Выцепляет игнорированные символы, выполняет блок с текстом
  # без этих символов а затем вставляет их на место     
  def lift_ignored(text, marker = "\xFF\xFF\xFF\xFF", &block)
    ignored = text.scan(@ignore)
    text.gsub!(@ignore, marker)
    
    # обрабатываем текст
    yield(text, marker) if block_given?       
    
    # возвращаем игнорированные символы
    ignored.each { | tag | text.sub!(marker, tag) }
  end

  # Кавычки - лапки     
  def process_simple_quotes(text)
      text.gsub!( /\"\"/ui, "&quot;&quot;")
      text.gsub!( /\"\.\"/ui, "&quot;.&quot;")
      _text = '""';
      while _text != text do  
        _text = text
        text.gsub!( /(^|\s|\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0|>)\"([0-9A-Za-z\'\!\s\.\?\,\-\&\;\:\_\xF0\xF0\xF0\xF0\xFF\xFF\xFF\xFF]+(\"|&#148;))/ui, '\1&#147;\2')
        #this doesnt work in-place. somehow.
        text.replace text.gsub( /(\&\#147\;([A-Za-z0-9\'\!\s\.\?\,\-\&\;\:\xF0\xF0\xF0\xF0\xFF\xFF\xFF\xFF\_]*).*[A-Za-z0-9][\xF0\xF0\xF0\xF0\xFF\xFF\xFF\xFF\?\.\!\,]*)\"/ui, '\1&#148;')
      end
  end
  
  # Кавычки - елочки
  def process_typographer_quotes(text)
    # 2. ёлочки
    text.gsub!( /\"\"/ui, "&quot;&quot;");
    text.gsub!( /(^|\s|\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0|>|\()\"((\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0)*[~0-9ёЁA-Za-zА-Яа-я\-:\/\.])/ui, "\\1&laquo;\\2");
    # nb: wacko only regexp follows:
    text.gsub!( /(^|\s|\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0|>|\()\"((\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0|\/&nbsp;|\/|\!)*[~0-9ёЁA-Za-zА-Яа-я\-:\/\.])/ui, "\\1&laquo;\\2")
    _text = "\"\"";
    while (_text != text) do
      _text = text;
      text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0)*)\"/sui, "\\1&raquo;")
      # nb: wacko only regexps follows:
      text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0)*\?(\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0)*)\"/sui, "\\1&raquo;")
      text.gsub!( /(\&laquo\;([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](\xFF\xFF\xFF\xFF|\xF0\xF0\xF0\xF0|\/|\!)*)\"/sui, "\\1&raquo;")
    end
  end
  
  # Cложные кавычки
  def process_compound_quotes(text)
    text.gsub!(/(\&\#147\;(([A-Za-z0-9'!\.?,\-&;:]|\s|\xF0\xF0\xF0\xF0|\xFF\xFF\xFF\xFF)*)&laquo;(.*)&raquo;)&raquo;/ui,"\\1&#148;");
  end

  # Обрабатывает короткое тире
  def process_dashes(text)
    text.gsub!( /(\s|;)\-(\s)/ui, "\\1&ndash;\\2")
  end
  
  # Обрабатывает длинные тире     
  def process_emdashes(text)
    text.gsub!( /(\s|;)\-\-(\s)/ui, "\\1&mdash;\\2")
  end

  # Обрабатывает знаки копирайта, торговой марки и т.д.
  def process_specials(text)
    # 4. (с)
    text.gsub!(/\([сСcC]\)((?=\w)|(?=\s[0-9]+))/u, "&copy;")
    # 4a. (r)
    text.gsub!( /\(r\)/ui, "<sup>&#174;</sup>")

    # 4b. (tm)
    text.gsub!( /\(tm\)|\(тм\)/ui, "&#153;")
    # 4c. (p)   
    text.gsub!( /\(p\)/ui, "&#167;")
  end
        
  # Склейка дефисоов
  def process_dashglue(text)
    text.gsub!( /([a-zа-яА-Я0-9]+(\-[a-zа-яА-Я0-9]+)+)/ui, '<nobr>\1</nobr>')
  end
  
  # Запятые и пробелы
  def process_spacing(text)
      text.gsub!( /(\s*)([,]*)/sui, "\\2\\1");
      text.gsub!( /(\s*)([\.?!]*)(\s*[ЁА-ЯA-Z])/su, "\\2\\1\\3");
  end
  
  # Неразрывные пробелы - пока глючит страшным образом
  def process_nonbreakables(text)
      text.replace " " + text + " ";
      _text = " " + text + " ";
      until _text == text
          _text.replace text.clone
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

  # Знак дюйма            
  def process_inches(text)
    text.gsub!(/\s([0-9]{1,2}([\.,][0-9]{1,2})?)\"/ui, ' \1&quot;') if @settings["inches"]
  end
  
  # Обрабатывает знак +/-
  def process_plusmin(text)
    text.gsub!(/\+\-/ui, "&#177;") if @settings["+-"]
  end
  
  # Обрабатывает телефоны
  def process_phones(text)
    @phonemasks[0].each_with_index do |regex, i|
      text.gsub!(regex, @phonemasks[1][i])
    end
  end
  
  # Обрабатывает знак градуса, набранный как caret
  def process_degrees(text)
    text.gsub!( /-([0-9])+\^([FCС])/, '&ndash;\1&#176\2')
    text.gsub!( /\+([0-9])+\^([FCС])/, "+\\1&#176\\2")
    text.gsub!( /\^([FCС])/, "&#176\\1")
  end
end