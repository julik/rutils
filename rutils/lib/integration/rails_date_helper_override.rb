if defined?(Object::ActionView)
  module Object::ActionView::Helpers::DateHelper

        # Заменяет ActionView::Helpers::DateHelper::distance_of_time_in_words на русское сообщение.
        #
        # Целые числа интерпретируются как секунды
        # <tt>distance_of_time_in_words(50)</tt> возвращает "меньше минуты".

        alias :stock_distance_of_time_in_words :distance_of_time_in_words
        def distance_of_time_in_words(*args)
          RuTils::overrides_enabled? ? RuTils::DateTime::distance_of_time_in_words(*args) : stock_distance_of_time_in_words
        end

        # Заменяет ActionView::Helpers::DateHelper::select_month меню выбора русских месяцев.
        #
        #   select_month(Date.today)                             # Использует ключи "Январь", "Март"
        #   select_month(Date.today, :use_month_numbers => true) # Использует ключи "1", "3"
        #   select_month(Date.today, :add_month_numbers => true) # Использует ключи "1 - Январь", "3 - Март"
        def select_month(date, options = {})
          month_options = [] 
          if RuTils::overrides_enabled?
            month_names = case true
              when options[:use_short_month]
                Date::RU_ABBR_MONTHNAMES
              when options[:order] && options[:order].include?(:day) # использование в контексте date_select с днями требует родительный падеж
                Date::RU_INFLECTED_MONTHNAMES
              else
                Date::RU_MONTHNAMES
            end
          else
            month_names = options[:use_short_month] ? Date::ABBR_MONTHNAMES : Date::MONTHNAMES
          end
          1.upto(12) do |month_number|
            month_name = if options[:use_month_numbers]
              month_number
            elsif options[:add_month_numbers]
              month_number.to_s + ' - ' + month_names[month_number]
            else
              month_names[month_number]
            end

            month_options << ((date && (date.kind_of?(Fixnum) ? date : date.month) == month_number) ?
              %(<option value="#{month_number}" selected="selected">#{month_name}</option>\n) :
              %(<option value="#{month_number}">#{month_name}</option>\n)
            )
          end
          
          select_html(options[:field_name] || 'month', month_options, options)
        end
        
        # Заменяет ActionView::Helpers::DateHelper::select_date меню выбора русской даты.
        def select_date(date = Date.today, options = {})
          options[:order] ||= []
          [:day, :month, :year].each { |o| options[:order].push(o) unless options[:order].include?(o) }
          
          select_date = ''
          options[:order].each do |o|
            select_date << self.send("select_#{o}", date, options)
          end
          select_date
        end

        # Заменяет ActionView::Helpers::DateHelper::select_datetime меню выбора русской даты.
        def select_datetime(datetime = Time.now, options = {})
          select_day(datetime, options) + select_month(datetime, options) + select_year(datetime, options) +
          select_hour(datetime, options) + select_minute(datetime, options)
        end
  end
end #endif