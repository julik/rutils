module RuTils
	module DateTime
		def self.distance_of_time_in_words(from_time, to_time = 0, include_seconds = false, absolute = false) #nodoc
			from_time = from_time.to_time if from_time.respond_to?(:to_time)
			to_time = to_time.to_time if to_time.respond_to?(:to_time)
			distance_in_minutes = (((to_time - from_time).abs)/60).round
			distance_in_seconds = ((to_time - from_time).abs).round

			case distance_in_minutes
				when 0..1
					return (distance_in_minutes==0) ? 'меньше минуты' : '1 минуту' unless include_seconds

				case distance_in_seconds
					 when 0..5	 then 'менее чем 5 секунд'
					 when 6..10	 then 'менее чем 10 секунд'
					 when 11..20 then 'менее чем 20 секунд'
					 when 21..40 then 'пол-минуты'
					 when 41..59 then 'меньше минуты'
					 else							'1 минуту'
				 end
														 
				 when 2..45			 then distance_in_minutes.items(2, "минута", "минуты", "минут") 
				 when 46..90		 then 'около часа'
				 when 90..1440	 then "около " + (distance_in_minutes.to_f / 60.0).round.items(1, "час", "часа", "часов")
				 when 1441..2880 then '1 день'
				 else									(distance_in_minutes / 1440).round.items(1,"день", "дня", "дней")
			 end
		end

	end
end