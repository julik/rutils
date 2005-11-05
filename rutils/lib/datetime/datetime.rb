#~ Убираем?
#~ require 'date'

module RuTils
	module DateTime
		ABBR_MONTHNAMES = [nil] + %w{ Янв Фев Мар Апр Май Июн Июл Авг Сен Окт Ноя Дек }
		MONTHNAMES = [nil] + %w{ Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь }
		INFLECTED_MONTHNAMES = [nil] + %w{ Января Февраля Марта Апреля Мая Июня Июля Авгуса Сентября Октября Ноября Декабря }
		DAYNAMES = %w(Воскресенье Понедельник Вторник Среда Четверг Пятница Суббота)
		ABBR_DAYNAMES = %w(Вск Пн Вт Ср Чт Пт Сб)
		
		MONTHNAMES_E = [nil] + %w{января февраля марта апреля мая июня июля августа сентября октября ноября декабря}
		DAYNAMES_E = [nil] + %w{первое второе третье четвёртое пятое шестое седьмое восьмое девятое десятое одиннадцатое двенадцатое тринадцатое четырнадцатое пятнадцатое шестнадцатое семнадцатое восемнадцатое девятнадцатое двадцатое двадцать тридцатое тридцатьпервое}
		
		def self.distance_of_time_in_words(from_time, to_time = 0, include_seconds = false, absolute = false) #nodoc
			from_time = from_time.to_time if from_time.respond_to?(:to_time)
			to_time = to_time.to_time if to_time.respond_to?(:to_time)
			distance_in_minutes = (((to_time - from_time).abs)/60).round
			distance_in_seconds = ((to_time - from_time).abs).round

			case distance_in_minutes
				when 0..1
					return (distance_in_minutes==0) ? 'меньше минуты' : '1 минуту' unless include_seconds

				case distance_in_seconds
					 when 0..5	 then 'менее 5 секунд'
					 when 6..10	 then 'менее 10 секунд'
					 when 11..20 then 'менее 20 секунд'
					 when 21..40 then 'пол-минуты'
					 when 41..59 then 'меньше минуты'
					 else					'1 минуту'
				 end
														 
				 when 2..45			 then distance_in_minutes.to_s + 
				                      " " + distance_in_minutes.items("минута", "минуты", "минут") 
				 when 46..90		 then 'около часа'
				 # исключение, сдвигаем на один влево чтобы соответствовать падежу
				 when 90..1440	 then "около " + (distance_in_minutes.to_f / 60.0).round.to_s + 
				                      " " + (distance_in_minutes.to_f / 60.0).round.items("часа", "часов", '')
				 when 1441..2880 then '1 день'
				 else									(distance_in_minutes / 1440).round.to_s + 
				                      " " + (distance_in_minutes / 1440).round.items("день", "дня", "дней")
			 end
		end
		
	end
end

#~ Убираем?
#~ class Date
	#~ def ru_strftime(*args)
		#~ RuTils::DateTime::RussianDate.new(self).strftime(*args)
	#~ end
#~ end

class Time
	def strftime_ru(date='%d.%m.%Y', r=RuTils::DateTime)
		# %e, %E отсутствуют в оригинале:
		#   %e - day of the month as a decimal number, a single digit is preceded by a space (range ' 1' to '31')
		#   %E - day of the month like "первое января"
		case self.day
			when 1..20		then day = r::DAYNAMES_E[self.day]
			when 21..29	then day = r::DAYNAMES_E[21] + r::DAYNAMES_E[self.day-20]
			when 30			then day = r::DAYNAMES_E[22]
			when 31			then day = r::DAYNAMES_E[23]
		end
		date.gsub!(/%E/, day + " " + r::MONTHNAMES_E[self.mon])
		date.gsub!(/%e/, self.day.to_s)
		
		date.gsub!(/%a/, r::ABBR_DAYNAMES[self.wday])
		date.gsub!(/%A/, r::DAYNAMES[self.wday])
		date.gsub!(/%b/, r::ABBR_MONTHNAMES[self.mon])
		date.gsub!(/%B/, r::MONTHNAMES[self.mon])
		self.strftime(date)
	end
end