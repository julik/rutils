$KCODE = 'u'
require 'jcode'

# Главный контейнер модуля
module RuTils
	VERSION = 0.11  #сюда нужен ревижн
end

require File.dirname(__FILE__) + '/pluralizer/pluralizer'
require File.dirname(__FILE__) + '/gilenson/gilenson_port' #Предельно идентичный порт Тыпографицы
#require File.dirname(__FILE__) + '/gilenson/gilenson' #Гиленсон, рефакторенный нами - todo
require File.dirname(__FILE__) + '/datetime/datetime' # Дата и время без локалей
require File.dirname(__FILE__) + '/transliteration/transliteration' # Транслит
require File.dirname(__FILE__) + '/integration/integration' # Интеграция с rails, textile и тд