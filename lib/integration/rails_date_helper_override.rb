# TODO синхронизироваться с AV::Helpers::DateHelper
# TODO документирование всех перегруженных методов "с нуля"
if defined?(Object::ActionView)
  module Object::ActionView::Helpers::DateHelper
    # Несколько хаков для корректной работы модуля с Rails 1.2--2.0 одновременно с Rails 2.1 и выше.

    # Хелперы DateHelper принимают параметр <tt>html_options</tt> (идет последним) начиная с Rails 2.1.
    # Нужно понять, имеем ли мы дело с Rails 2.1+, для этого проверяем наличие классметода helper_modules у
    # ActionView::Base, который появился как раз в версии 2.1.
    DATE_HELPERS_RECEIVE_HTML_OPTIONS = ActionView::Base.respond_to?(:helper_modules)

    # В Rails Edge (2.1+) определяется <tt>Time.current</tt> для работы с временными зонами.
    unless Time.respond_to? :current
      class << ::Time
        def current; now; end
      end
    end
    
    # Заменяет <tt>ActionView::Helpers::DateHelper::distance_of_time_in_words</tt> на русское сообщение.
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
    def select_month(date, options = {}, html_options = {})
      val = date ? (date.kind_of?(Fixnum) ? date : date.month) : ''
      if options[:use_hidden]
        hidden_html(options[:field_name] || 'month', val, options)
      else
        month_options = [] 
        if RuTils::overrides_enabled?
          month_names = case true
            when options[:use_short_month]
              Date::RU_ABBR_MONTHNAMES
            # использование в контексте date_select с днями требует родительный падеж
            when options[:order] && options[:order].include?(:day)
              Date::RU_INFLECTED_MONTHNAMES
            else
              Date::RU_MONTHNAMES
          end
        else
          month_names = options[:use_short_month] ? Date::ABBR_MONTHNAMES : Date::MONTHNAMES
        end
        month_names.unshift(nil) if month_names.size < 13
        1.upto(12) do |month_number|
          month_name = if options[:use_month_numbers]
            month_number
          elsif options[:add_month_numbers]
            month_number.to_s + ' - ' + month_names[month_number]
          else
            month_names[month_number]
          end
    
          month_options << ((val == month_number) ?
            content_tag(:option, month_name, :value => month_number, :selected => "selected") :
            content_tag(:option, month_name, :value => month_number)
          )
          month_options << "\n"
        end
        if DATE_HELPERS_RECEIVE_HTML_OPTIONS
          select_html(options[:field_name] || 'month', month_options.join, options, html_options)
        else
          select_html(options[:field_name] || 'month', month_options.join, options)
        end
      end
    end
    
    # Заменяет ActionView::Helpers::DateHelper::select_date меню выбора русской даты.
    # def select_date(date = Date.today, options = {}, html_options = {})
    #   options[:order] ||= []
    #   [:day, :month, :year].each { |o| options[:order].push(o) unless options[:order].include?(o) }
    #   
    #   select_date = ''
    #   options[:order].each do |o|
    #     if DATE_HELPERS_RECEIVE_HTML_OPTIONS
    #       select_date << self.send("select_#{o}", date, options, html_options)
    #     else
    #       select_date << self.send("select_#{o}", date, options)
    #     end
    #   end
    #   select_date
    # end
    
    alias :stock_select_date :select_date
    # Заменяет ActionView::Helpers::DateHelper::select_date меню выбора русской даты.
    def select_date(date = Date.today, options = {}, html_options = {})
      options[:order] ||= [:day, :month, :year]
      if DATE_HELPERS_RECEIVE_HTML_OPTIONS
        stock_select_date(date, options, html_options)
      else
        stock_select_date(date, options)
      end
    end
  end
  
  module Object::ActionView::Helpers
    if defined?(InstanceTag) && InstanceTag.private_method_defined?(:date_or_time_select)
      class InstanceTag #:nodoc:
        private
          alias :stock_date_or_time_select :date_or_time_select
          def date_or_time_select(options, html_options = {})
            options[:order] ||= [:day, :month, :year]
            if DATE_HELPERS_RECEIVE_HTML_OPTIONS
              stock_date_or_time_select(options, html_options)
            else
              stock_date_or_time_select(options)
            end
          end
      end
    end
  end
  
end #endif