if defined?(ActionView)
  module ActionView  #:nodoc:
    module Helpers
      module DateHelper

        # Reports the approximate distance in time between two Time objects or integers. 
        # For example, if the distance is 47 minutes, it'll return
        # "about 1 hour". See the source for the complete wording list.
        #
        # Integers are interpreted as seconds. So,
        # <tt>distance_of_time_in_words(50)</tt> returns "less than a minute".
        #
        # Set <tt>include_seconds</tt> to true if you want more detailed approximations if distance < 1 minute

        alias :stock_distance_of_time_in_words :distance_of_time_in_words
        def distance_of_time_in_words(*args)
          RuTils::overrides_enabled? ? RuTils::DateTime::distance_of_time_in_words(*args) : stock_distance_of_time_in_words
        end

        # Like distance_of_time_in_words, but where <tt>to_time</tt> is fixed to <tt>Time.now</tt>.
        def time_ago_in_words(from_time, include_seconds = false)
          distance_of_time_in_words(from_time, Time.now, include_seconds)
        end

        # Returns a select tag with options for each of the months January through December with the current month selected.
        # The month names are presented as keys (what's shown to the user) and the month numbers (1-12) are used as values
        # (what's submitted to the server). It's also possible to use month numbers for the presentation instead of names --
        # set the <tt>:use_month_numbers</tt> key in +options+ to true for this to happen. If you want both numbers and names,
        # set the <tt>:add_month_numbers</tt> key in +options+ to true. Examples:
        #
        #   select_month(Date.today)                             # Will use keys like "January", "March"
        #   select_month(Date.today, :use_month_numbers => true) # Will use keys like "1", "3"
        #   select_month(Date.today, :add_month_numbers => true) # Will use keys like "1 - January", "3 - March"
        #
        # Override the field name using the <tt>:field_name</tt> option, 'month' by default.
        #
        # If you would prefer to show month names as abbreviations, set the
        # <tt>:use_short_month</tt> key in +options+ to true.
        def select_month(date, options = {})
          month_options = []
          if RuTils::overrides_enabled?
            month_names = options[:use_short_month] ? RuTils::DateTime::ABBR_MONTHNAMES : RuTils::DateTime::MONTHNAMES            
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