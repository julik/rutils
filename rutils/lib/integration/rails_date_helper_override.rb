if defined?(Object::ActionView)
  module Object::ActionView  #:nodoc:
    module Helpers
      module DateHelper

        # Заменяет ActionView::Helpers::DateHelper::distance_of_time_in_words на русское сообщение.
        #
        # Целые числа интерпретируются как секунды
        # <tt>distance_of_time_in_words(50)</tt> возвращает "меньше минуты".

        alias :stock_distance_of_time_in_words :distance_of_time_in_words
        def distance_of_time_in_words(*args)
          RuTils::overrides_enabled? ? RuTils::DateTime::distance_of_time_in_words(*args) : stock_distance_of_time_in_words
        end

        # Like distance_of_time_in_words, but where <tt>to_time</tt> is fixed to <tt>Time.now</tt>.
        def time_ago_in_words(from_time, include_seconds = false)
          distance_of_time_in_words(from_time, Time.now, include_seconds)
        end

        # Заменяет ActionView::Helpers::DateHelper::select_month меню выбора русской даты.
        #
        #   select_month(Date.today)                             # Использует ключи "Январь", "Март"
        #   select_month(Date.today, :use_month_numbers => true) # Использует ключи "1", "3"
        #   select_month(Date.today, :add_month_numbers => true) # Использует ключи "1 - Январь", "3 - Март"
        def select_month(date, options = {})
          month_options = []
          if RuTils::overrides_enabled?
            month_names = options[:use_short_month] ? RuTils::DateTime::ABBR_MONTHNAMES : RuTils::DateTime::INFLECTED_MONTHNAMES            
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

          select_html(options[:field_name] || 'month', month_options, options[:prefix], options[:include_blank], options[:discard_type], options[:disabled])
        end
      end
    end
  end
end #endif