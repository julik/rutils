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
  VERSION = [MAJOR, MINOR ,TINY].join('.')
  
  def self.load_component(name) #:nodoc:
    require RuTils::INSTALLATION_DIRECTORY + "/lib/#{name}/#{name}"
  end

  def self.reload_component(name) #:nodoc:
    load RuTils::INSTALLATION_DIRECTORY + "/lib/#{name}/#{name}.rb"
  end
end


RuTils::load_component :pluralizer #Выбор числительного и сумма прописью
require File.dirname(__FILE__) + '/gilenson/gilenson_port'
# RuTils::load_component :gilenson_port
RuTils::load_component :datetime # Дата и время без локалей
RuTils::load_component :transliteration # Транслит
RuTils::load_component :integration # Интеграция с rails, textile и тд
RuTils::load_component :countries # Данные о странах на русском и английском