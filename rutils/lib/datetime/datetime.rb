module RuTils
	module Datetime
		def self.format(object, format_string)
			case object
				when Date
					object.rfc_822 #blablabla
				when Time
					object.rfc_822 #blablabla
				when DateTime
					object.rfc_822 #blablabla
			end
		end
	end
end