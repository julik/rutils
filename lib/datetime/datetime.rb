# -*- encoding: utf-8 -*- 
module RuTils
  module DateTime
    
    RU_MONTHNAMES = [nil] + %w{ январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь }
    RU_DAYNAMES = %w(воскресенье понедельник вторник среда четверг пятница суббота)
    RU_ABBR_MONTHNAMES = [nil] + %w{ янв фев мар апр май июн июл авг сен окт ноя дек }
    RU_ABBR_DAYNAMES = %w(вск пн вт ср чт пт сб)
    RU_INFLECTED_MONTHNAMES = [nil] + %w{ января февраля марта апреля мая июня июля августа сентября октября ноября декабря }
    RU_DAYNAMES_E = [nil] + %w{первое второе третье четвёртое пятое шестое седьмое восьмое девятое десятое одиннадцатое двенадцатое тринадцатое четырнадцатое пятнадцатое шестнадцатое семнадцатое восемнадцатое девятнадцатое двадцатое двадцать тридцатое тридцатьпервое}
    
    def self.distance_of_time_in_words(from_time, to_time = 0, include_seconds = false, absolute = false) #nodoc
      from_time = from_time.to_time if from_time.respond_to?(:to_time)
      to_time   = to_time.to_time if to_time.respond_to?(:to_time)
      distance_in_minutes = (((to_time - from_time).abs)/60).round
      distance_in_seconds = ((to_time - from_time).abs).round
      
      case distance_in_minutes
        when 0..1
          return (distance_in_minutes==0) ? 'меньше минуты' : '1 минуту' unless include_seconds
        
        case distance_in_seconds
           when 0..5   then 'менее 5 секунд'
           when 6..10  then 'менее 10 секунд'
           when 11..20 then 'менее 20 секунд'
           when 21..40 then 'пол-минуты'
           when 41..59 then 'меньше минуты'
           else             '1 минуту'
         end
        
         when 2..45      then distance_in_minutes.to_s + 
                              " " + distance_in_minutes.items("минута", "минуты", "минут") 
         when 46..90     then 'около часа'
         
         # исключение, сдвигаем на один влево чтобы соответствовать падежу
         when 90..1440   then "около " + (distance_in_minutes.to_f / 60.0).round.to_s + 
                              " " + (distance_in_minutes.to_f / 60.0).round.items("часа", 'часов', 'часов')
         when 1441..2880 then '1 день'
         else                  (distance_in_minutes / 1440).round.to_s + 
                              " " + (distance_in_minutes / 1440).round.items("день", "дня", "дней")
       end
    end
    
    def self.ru_strftime(time, format_str='%d.%m.%Y') #;yields: replaced time string
      clean_fmt = format_str.to_s.gsub(/%{2}/, RuTils::SUBSTITUTION_MARKER).
        gsub(/%a/, RU_ABBR_DAYNAMES[time.wday]).
        gsub(/%A/, RU_DAYNAMES[time.wday]).
        gsub(/%b/, RU_ABBR_MONTHNAMES[time.mon]).
        gsub(/%d(\s)*%B/, '%02d' % time.day + '\1' + RU_INFLECTED_MONTHNAMES[time.mon]).
        gsub(/%e(\s)*%B/, '%d' % time.day + '\1' + RU_INFLECTED_MONTHNAMES[time.mon]).
        gsub(/%B/, RU_MONTHNAMES[time.mon]).
        gsub(/#{RuTils::SUBSTITUTION_MARKER}/, '%%')
      # Теперь когда все нужные нам маркеры заменены можно отдать это стандартному strftime
      if block_given?
        yield(clean_fmt) 
      else
        time.strftime(clean_fmt)
      end
    end
    
    module RuStrftime
      def self.included(into)
        if instance_methods.include?(:strftime_norutils)
          return super
        end
        
        into.send(:alias_method, :strftime_norutils, :strftime)
        into.send(:define_method, :strftime) do | fmt |
          if RuTils::overrides_enabled?
            RuTils::DateTime::ru_strftime(self, fmt) {| fmt_with_replacements | strftime_norutils(fmt_with_replacements) }
          else
            strftime_norutils(fmt)
          end
        end
        
        super
      end
    end
    
    # Включаем всякие оверрайды только если версия Ruby старая.
    # Лазить в чужие кишки немытыми руками нехорошо.
    if defined?(::DateTime)
      ::DateTime.send(:include, RuStrftime)
    end
    
    ::Time.send(:include, RuStrftime)
    if defined?(::Date)
      ::Date.send(:include, RuStrftime)
    end
  end
end