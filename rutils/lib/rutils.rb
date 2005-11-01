$KCODE = 'u'
require 'jcode' # вот от этого надо бы избавиться - скопировать jsize из jcode и поместить его в свой namespace


# Главный контейнер модуля
module RuTils
  # Папка, куда установлен модуль RuTils. Нужно чтобы автоматически копировать RuTils в другие приложения.
  INSTALLATION_DIRECTORY = File.expand_path(File.dirname(__FILE__) + '/../')
  MAJOR = 0
  MINOR = 1
  TINY = 2

  # Версия RuTils
	VERSION = "#{MAJOR}.#{MINOR}.#{TINY}"
end

require File.dirname(__FILE__) + '/pluralizer/pluralizer'
require File.dirname(__FILE__) + '/gilenson/gilenson_port' #Предельно идентичный порт Тыпографицы
#require File.dirname(__FILE__) + '/gilenson/gilenson' #Гиленсон, рефакторенный нами - todo
require File.dirname(__FILE__) + '/datetime/datetime' # Дата и время без локалей
require File.dirname(__FILE__) + '/transliteration/transliteration' # Транслит
require File.dirname(__FILE__) + '/integration/integration' # Интеграция с rails, textile и тд