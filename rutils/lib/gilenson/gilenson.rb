module RuTils
  module GilensonNew  
    # Обработчик типографицы согласно общепринятым правилам. Пока присутствует только в CVS.
    # Создается сразу с текстом предназначенным к обработке
    #
    #   typ = RuTils::GilensonNew::Typografica.new('Эти "так называемые" великие деятели')
    #   typ.to_html => 'Эти &#171;так называемые&#187; великие деятели'
    # 
    #  или как фильтр
    #   formatter = RuTils::GilensonNew::Formatter.new
    #   for string in strings
    #     puts formatter.process(string)
    #
    #
    # Настройки регулируются через методы
    #   formatter.dashglue = true
    # или ассоциированным хешем
    #   formatter.configure!(:dash=>true, :quotes=>false)
    #
    # Хеш также можно передавать как последний аргумент методам process и to_html,
    # в таком случае настройки будут применены только при этом вызове
    #
    #   beautified = formatter.process(my_text, :dash=>true)
    #
    class Formatter
      attr_accessor :glyph
    

      # Обрабатывает text_to_process Гиленсоном с сохранением настроек, присвоенных форматтеру
      # Дополнительные аргументы передаются как параметры форматтера и не сохраняются после прогона.
      def process(text_to_process, *args)
        @_text = text_to_process
        if args.last.is_a?(Hash)
          with_configuration(args.last) { self.to_html }
        else
          self.to_html
        end
      end
    
    
      # Создает новый экземпляр форматтера. Если первый аргумент - текст, форматтер вернет этот текст
      # отформатированным при вызове to_html.
      def initialize(*args)
        @_text = args[0].is_a?(String) ? args[0] : ''
        setup_default_settings!
        accept_configuration_arguments!(args.last) if args.last.is_a?(Hash)
      end
      
      def configure!(*config)
        accept_configuration_arguments!(config.last) if config.last.is_a?(Hash)
      end
    
      # Proxy unknown method calls as setting switches. Methods with = will set settings, methods without - fetch them
      def method_missing(meth, *args) #:nodoc:
        setting = meth.to_s.gsub(/=$/, '')
        super(meth, *args) unless @settings.has_key?(setting) #this will pop the exception if we have no such setting
      
        return (@settings[setting] = args[0])
      end


      def to_html()

        text = @_text


        # Никогда (вы слышите?!) не пущать лабуду &#not_correct_number;
        @glyph_ugly.each { | key, proc | text.gsub!(/&##{key};/, proc.call) }
        
        # Чистим copy&paste
        if @settings['copypaste']
          process_copy_paste_clearing(text)
        end
        
        # Замена &entity_name; на входе ('&nbsp;' => '&#160;' и т.д.)
        self.glyph.each { |key, value| text.gsub!(/&#{key};/, value)}


        # -2. игнорируем ещё регексп
        ignored = []
  
        text.scan(@ignore) do |result|
          ignored << result
        end

        text.gsub!(@ignore, @mark_ignored)  # маркер игнора

        # -1. запрет тагов html
        text.gsub!(/&/, self.glyph[:amp]) if @settings["html"]


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
        if @skip_tags
        #     re =  /<\/?[a-z0-9]+("+ # имя тага
        #                              "\s+("+ # повторяющая конструкция: хотя бы один разделитель и тельце
        #                                     "[a-z]+("+ # атрибут из букв, за которым может стоять знак равенства и потом
        #                                              "=((\'[^\']*\')|(\"[^\"]*\")|([0-9@\-_a-z:\/?&=\.]+))"+ # 
        #                                           ")?"+
        #                                  ")?"+
        #                            ")*\/?>|\xA2\xA2[^\n]*?==/i;

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
        # --- не портировано ---
        # --- а оно надо?  ---

        # 3. Спецсимволы
        # 0. дюймы с цифрами
        # заменено на инчи
        text.gsub!(/\s([0-9]{1,2}([\.,][0-9]{1,2})?)\"/ui, ' \1'+self.glyph[:inch]) if @settings["inches"]

        # 1. лапки
        if @settings["quotes"]
          text.gsub!( /\"\"/ui, self.glyph[:quot]*2)
          text.gsub!( /\"\.\"/ui, self.glyph[:quot]+"."+self.glyph[:quot])
          _text = '""';
          while _text != text do  
            _text = text
            text.gsub!( /(^|\s|#{@mark_ignored}|#{@mark_tag}|>)\"([0-9A-Za-z\'\!\s\.\?\,\-\&\;\:\_#{@mark_tag}#{@mark_ignored}]+(\"|#{self.glyph[:rdquo]}))/ui, '\1'+self.glyph[:ldquo]+'\2')
            #this doesnt work in-place. somehow.
            text = text.gsub( /(#{self.glyph[:ldquo]}([A-Za-z0-9\'\!\s\.\?\,\-\&\;\:#{@mark_tag}#{@mark_ignored}\_]*).*[A-Za-z0-9][#{@mark_tag}#{@mark_ignored}\?\.\!\,]*)\"/ui, '\1'+self.glyph[:rdquo])
          end
        end

        # 2. ёлочки
        if @settings["laquo"]
          text.gsub!( /\"\"/ui, self.glyph[:quot]*2);
          text.gsub!( /(^|\s|#{@mark_ignored}|#{@mark_tag}|>|\()\"((#{@mark_ignored}|#{@mark_tag})*[~0-9ёЁA-Za-zА-Яа-я\-:\/\.])/ui, '\1'+self.glyph[:laquo]+'\2');
          # nb: wacko only regexp follows:
          # text.gsub!( /(^|\s|#{@mark_ignored}|#{@mark_tag}|>|\()\"((#{@mark_ignored}|#{@mark_tag}|\/#{self.glyph[:nbsp]}|\/|\!)*[~0-9ёЁA-Za-zА-Яа-я\-:\/\.])/ui, '\1'+self.glyph[:laquo]+'\2')
          _text = '""';
          while (_text != text) do
            _text = text;
            text.gsub!( /(#{self.glyph[:laquo]}([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](#{@mark_ignored}|#{@mark_tag})*)\"/sui, '\1'+self.glyph[:raquo])
            # nb: wacko only regexps follows:
            # text.gsub!( /(#{self.glyph[:laquo]}([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](#{@mark_ignored}|#{@mark_tag})*\?(#{@mark_ignored}|#{@mark_tag})*)\"/sui, '\1'+self.glyph[:raquo])
            # text.gsub!( /(#{self.glyph[:raquo]}([^\"]*)[ёЁA-Za-zА-Яа-я0-9\.\-:\/](#{@mark_ignored}|#{@mark_tag}|\/|\!)*)\"/sui, '\1'+self.glyph[:raquo])
          end
        end


        # 2b. одновременно ёлочки и лапки
        if (@settings["quotes"] && (@settings["laquo"] or @settings["farlaquo"]))
          text.gsub!(/(#{self.glyph[:ldquo]}(([A-Za-z0-9'!\.?,\-&;:]|\s|#{@mark_tag}|#{@mark_ignored})*)#{self.glyph[:laquo]}(.*)#{self.glyph[:raquo]})#{self.glyph[:raquo]}/ui,'\1'+self.glyph[:rdquo]);
        end


        # 3. тире
        if @settings["dash"]
          text.gsub!( /(\s|;)\-(\s)/ui, '\1'+self.glyph[:ndash]+'\2')
        end


        # 3a. тире длинное
        if @settings["emdash"]
          text.gsub!( /(\s|;)\-\-(\s)/ui, '\1'+self.glyph[:mdash]+'\2')
          # 4. (с)
          text.gsub!(/\([сСcC]\)((?=\w)|(?=\s[0-9]+))/u, self.glyph[:copy]) if @settings["(c)"]
          # 4a. (r)
          text.gsub!( /\(r\)/ui, '<sup>'+self.glyph[:reg]+'</sup>') if @settings["(r)"]

          # 4b. (tm)
          text.gsub!( /\(tm\)|\(тм\)/ui, self.glyph[:trade]) if @settings["(tm)"]
          # 4c. (p)   
          text.gsub!( /\(p\)/ui, self.glyph[:sect]) if @settings["(p)"]
        end


        # 5. +/-
        text.gsub!(/[^+]\+\-/ui, self.glyph[:plusmn]) if @settings["+-"]


        # 5a. 12^C
        if @settings["degrees"]
          text.gsub!( /-([0-9])+\^([FCС])/, self.glyph[:ndash]+'\1'+self.glyph[:deg]+'\2') #deg
          text.gsub!( /\+([0-9])+\^([FCС])/, '+\1'+self.glyph[:deg]+'\2')
          text.gsub!( /\^([FCС])/, self.glyph[:deg]+'\1')
        end


        # 6. телефоны
        if @settings["phones"]
          @phonemasks[0].each_with_index do |pattern, i|
            replacement = substitute_glyphs_in_string(@phonemasks[1][i])
            text.gsub!(pattern, replacement)
          end
        end


        # 7. Короткие слова и &nbsp;
        if @settings["wordglue"]

          text = " " + text + " ";
          _text = " " + text + " ";
          until _text == text
             _text = text
             text.gsub!( /(\s+)([a-zа-яА-Я]{1,2})(\s+)([^\\s$])/ui, '\1\2'+self.glyph[:nbsp]+'\4')
             text.gsub!( /(\s+)([a-zа-яА-Я]{3})(\s+)([^\\s$])/ui,   '\1\2'+self.glyph[:nbsp]+'\4')
          end

          for i in @glueleft
             text.gsub!( /(\s)(#{i})(\s+)/sui, '\1\2'+self.glyph[:nbsp])
          end

          for i in @glueright 
             text.gsub!( /(\s)(#{i})(\s+)/sui, self.glyph[:nbsp]+'\2\3')
          end
        end


        # 8. Склейка ласт. Тьфу! дефисов.
        text.gsub!( /([a-zа-яА-Я0-9]+(\-[a-zа-яА-Я0-9]+)+)/ui, '<nobr>\1</nobr>') if @settings["dashglue"]

        # 8a. Инициалы
        if @settings['initials']
          process_initials(text)
        end

        # БЕСКОНЕЧНОСТЬ. Вставляем таги обратно.
        tags.each do |tag|
          #~ text.sub!(@mark_tag, tag)
          text.sub!(@mark_tag.to_s, tag)
        end


        # БЕСКОНЕЧНОСТЬ-2. вставляем ещё сигнорированный регексп
        #
  #      if @ignore
  #        ignored.each { | tag | text.sub!(@mark_ignored.to_s, tag) }
  #      end

  #      raise "Text still has ignored markers!" if text.include?("\201")


        # фуф, закончили.
        if @settings["de_nobr"]
          text.gsub!(/<nobr>/, '<span class="nobr">')
          text.gsub!(/<\/nobr>/, '</span>')
        end

        text.gsub(/(\s)+$/, "").gsub(/^(\s)+/, "")
      end
      
      private
      
        def setup_default_settings!
          @skip_tags = true;
           @ignore = /notypo/ # regex, который игнорируется. Этим надо воспользоваться для обработки pre и code

           @glueleft =  ['рис.', 'табл.', 'см.', 'им.', 'ул.', 'пер.', 'кв.', 'офис', 'оф.', 'г.']
           @glueright = ['руб.', 'коп.', 'у.е.', 'мин.']

           @settings = {
                         "inches"    => true,    # преобразовывать дюймы в знак дюйма;
                         "laquo"     => true,    # кавычки-ёлочки
                         "farlaquo"  => false,   # кавычки-ёлочки для фара (знаки "больше-меньше")
                         "quotes"    => true,    # кавычки-английские лапки
                         "dash"      => true,    # короткое тире (150)
                         "emdash"    => true,    # длинное тире двумя минусами (151)
                         "initials"  => true,    # тонкие шпации в инициалах
                         "copypaste" => false,   # вычистка "copy&paste" символов
                         "(c)"       => true,
                         "(r)"       => true,
                         "(tm)"      => true,
                         "(p)"       => true,
                         "+-"        => true,    # спецсимволы, какие - понятно
                         "degrees"   => true,    # знак градуса
                         "dashglue"  => true, "wordglue" => true, # приклеивание предлогов и дефисов
                         "spacing"   => true,    # запятые и пробелы, перестановка
                         "phones"    => true,    # обработка телефонов
                         "fixed"     => false,   # подгон под фиксированную ширину
                         "html"      => false,   # запрет тагов html
                         "de_nobr"   => false,   # при true все <nobr/> заменяются на <span class="nobr"/>
                        }

           # note: именно в одиночных кавычках, важно для регэкспов
           # дальше делаем to_s там, где это понадобится
           @mark_tag = '\xF0\xF0\xF0\xF0' # Подстановочные маркеры тегов
           @mark_ignored = '\201' # Подстановочные маркеры неизменяемых групп - надо заменить!

           # XHTML... Даёшь!
           @glyph = {
                         :quot       => "&#34;",     # quotation mark
                         :amp        => "&#38;",     # ampersand
                         :apos       => "&#39;",     # apos
                         :gt         => "&#62;",     # greater-than sign
                         :lt         => "&#60;",     # less-than sign
                         :nbsp       => "&#160;",    # non-breaking space
                         :sect       => "&#167;",    # section sign
                         :copy       => "&#169;",    # copyright sign
                         :laquo      => "&#171;",    # left-pointing double angle quotation mark = left pointing guillemet
                         :reg        => "&#174;",    # registered sign = registered trade mark sign
                         :deg        => "&#176;",    # degree sign
                         :plusmn     => "&#177;",    # plus-minus sign = plus-or-minus sign
                         :para       => "&#182;",    # pilcrow sign = paragraph sign
                         :middot     => "&#183;",    # middle dot = Georgian comma = Greek middle dot
                         :raquo      => "&#187;",    # right-pointing double angle quotation mark = right pointing guillemet
                         :ndash      => "&#8211;",   # en dash
                         :mdash      => "&#8212;",   # em dash
                         :lsquo      => "&#8216;",   # left single quotation mark
                         :rsquo      => "&#8217;",   # right single quotation mark
                         :ldquo      => "&#8220;",   # left double quotation mark
                         :rdquo      => "&#8221;",   # right double quotation mark
                         :bdquo      => "&#8222;",   # double low-9 quotation mark
                         :bull       => "&#8226;",   # bullet = black small circle
                         :hellip     => "&#8230;",   # horizontal ellipsis = three dot leader
                         :numero     => "&#8470;",   # numero
                         :trade      => "&#8482;",   # trade mark sign
                         :minus      => "&#8722;",   # minus sign
                         :inch       => "&#8243;",   # inch/second sign (u0x2033) (не путать с кавычками!)
                         :thinsp     => "&#8201;",   # полукруглая шпация (тонкий пробел)
                         :nob_open   => '<nobr>',    # открывающий блок без переноса слов
                         :nob_close   => '</nobr>',    # открывающий блок без переноса слов
                    }

           # Кто придумал &#147;? Не учите людей плохому...
           # Привет А.Лебедеву http://www.artlebedev.ru/kovodstvo/62/
           # Используем Proc потому что надо получить значение из обьекта после того как
           # определены эти значения
           @glyph_ugly = {
                         '132'       => lookup(:bdquo),
                         '133'       => lookup(:hellip),
                         '146'       => lookup(:apos),
                         '147'       => lookup(:ldquo),
                         '148'       => lookup(:rdquo),
                         '149'       => lookup(:bull),
                         '150'       => lookup(:ndash),
                         '151'       => lookup(:mdash),
                         '153'       => lookup(:trade),
                    }

           # чистим copy&paste
           @glyph_copy_paste = {
                         ' '         => lookup(:nbsp),# alt+0160 (NBSP here)
                         '«'         => lookup(:laquo),
                         '»'         => lookup(:raquo),
                         '§'         => lookup(:sect),
                         '©'         => lookup(:copy),
                         '®'         => lookup(:reg),
                         '°'         => lookup(:deg),
                         '±'         => lookup(:plusmn),
                         '¶'         => lookup(:para),
                         '·'         => lookup(:middot),
                         '–'         => lookup(:ndash),
                         '—'         => lookup(:mdash),
                         '‘'         => lookup(:lsquo),
                         '’'         => lookup(:rsquo),
                         '“'         => lookup(:ldquo),
                         '”'         => lookup(:rdquo),
                         '„'         => lookup(:bdquo),
                         '•'         => lookup(:bull),
                         '…'         => lookup(:hellip),
                         '№'         => lookup(:numero),
                         '™'         => lookup(:trade),
                         '−'         => lookup(:minus),
                         ' '         => lookup(:thinsp),
                         '″'         => lookup(:inch),
                    }

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
                            ':nob_open\1:ndash\2:ndash\3:nbsp\4:\5:\6:nob_close',
                            ':nob_open\1:ndash\2:ndash\3:nob_close',
                            ':nob_open\1:nbsp\2:ndash\3:ndash\4:nob_close',
                            ':nob_open\1:nbsp\2:ndash\3:ndash\4:nob_close',
                            ':nob_open\1:nbsp\2:ndash\3:nob_close',
                            ':nob_open\1:nbsp\2:ndash\3:nob_close',
                            ':nob_open\1:ndash\2:ndash\3:nob_close',
                            ':nob_open\1:ndash\2:ndash\3:nob_close',
                            ':nob_open\1:ndash\2:ndash\3:nob_close',
                            ':nob_open\1:ndash\2:nob_close',
                            ':nob_open\1:ndash\2:nob_close'
                         ]]
        end
        
        # Позволяет получить значение глифа
        def lookup(glyph_to_lookup)
          gil = self
          return Proc.new { gil.glyph[glyph_to_lookup] }
        end

        # Подставляет "символы" (двоеточие + имя глифа) на нужное значение глифа заданное в данном форматтере
        def substitute_glyphs_in_string(str)
          ret = str.dup
          @glyph.each_pair do | key, subst |
            ret.gsub!(":#{key.to_s}", subst)
          end
          ret
        end

        # Выполняет блок, временно включая настройки переданные в +hash+
        def with_configuration(hash, &block)
          old_settings, old_glyphs = @settings.dup, @glyph.dup
          accept_configuration_arguments!(hash)
            txt = yield
          @settings, @glyph = old_settings, old_glyphs
          
          return txt
        end
        
        def accept_configuration_arguments!(args_hash)
          
          # Специальный случай - :all=>true|false
          if args_hash.has_key?(:all)
            if args_hash[:all]
              @settings.each_pair {|k, v| @settings[k] = true}
            else
              @settings.each_pair {|k, v| @settings[k] = false}
            end
          else          
            args_hash.each_pair do | key, value |
              @settings[key.to_s] = (value ? true : false)
            end
          end
        end
        
        def process_initials(text)
          initials = /([А-Я])[\.]*?[\s]*?([А-Я])[\.]*[\s]*?([А-Я])([а-я])/u
          replacement = substitute_glyphs_in_string('\1.\2.:thinsp\3\4')
          text.gsub!(initials, replacement)
        end
    
        def process_copy_paste_clearing(text)
          # Чистим copy&paste
          @glyph_copy_paste.each {|key,value| text.gsub!(/#{key}/, value.call(self))}
        end
    end
  end #end Gilenson
end #end RuTils

module RuTils::Gilenson::NewStringFormatting
  # Форматирует строку с помощью GilensonNew. Всп дополнительные опции передаются форматтеру.
  def n_gilensize(*args)
    args = {} unless args.is_a?(Hash)
    RuTils::GilensonNew::Formatter.new(self, *args).to_html
  end
end


class Object::String
  include RuTils::Gilenson::NewStringFormatting
end