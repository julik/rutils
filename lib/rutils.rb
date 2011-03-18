# -*- encoding: utf-8 -*- 
$KCODE = 'u' if RUBY_VERSION < '1.9.0'

require File.expand_path(File.dirname(__FILE__)) + '/version'

# Главный контейнер модуля
module RuTils
  # Папка, куда установлен модуль RuTils. Нужно чтобы автоматически копировать RuTils в другие приложения.
  INSTALLATION_DIRECTORY = File.expand_path(File.dirname(__FILE__) + '/../') #:nodoc:
  
  # Стандартный маркер для подстановок - Unicode Character 'OBJECT REPLACEMENT CHARACTER' (U+FFFC)
  # http://unicode.org/reports/tr20/tr20-1.html
  # Он официально применяется для обозначения вложенного обьекта
  SUBSTITUTION_MARKER = [0xEF, 0xBF, 0xBC].pack("U*").freeze
  
  class RemovedFeature < RuntimeError
  end
  
  # Метод позволяет проверить, включена ли перегрузка функций других модулей.
  # Попутно он спрашивает модуль Locale (если таковой имеется) является ли русский
  # текущим языком, и если является, включает перегрузку функций имплицитно.
  # Это позволяет подчинить настройку перегруженных функций настроенной локали.
  # Модуль Locale можно получить как часть Ruby-Gettext или как отдельный
  # модуль ruby-locale. Мы поддерживаем оба.
  def overrides_enabled?
    if defined?(Locale) and Locale.respond_to?(:current)
      return true if Locale.current.to_s.split('_').first == 'ru'
    end
    thread_local_or_own_flag ? true : false
  end
  alias_method :overrides, :overrides_enabled?
  module_function :overrides_enabled?
  
  # Включает или выключает перегрузки других модулей. Полезно, например, в случае когда нужно рендерить страницу
  # сайта на нескольких языках и нужно отключить русское оформление текста для других языков.  
  #
  # Флаг overrides в RuTils работают в контексте текущей нити
  def overrides=(new_override_flag)
    Thread.current[:rutils_overrides_enabled] = (new_override_flag ? true : false)
  end
  module_function :overrides=
  
  def self.thread_local_or_own_flag #:nodoc:
    # Это может быть умирает на 1.9.2
    Thread.current[:rutils_overrides_enabled] || false
  end
  
  def self.load_component(name) #:nodoc:
    require File.join(RuTils::INSTALLATION_DIRECTORY, "lib", name.to_s, name.to_s)
  end
end

require File.join(RuTils::INSTALLATION_DIRECTORY, "lib/pluralizer/pluralizer")
require File.join(RuTils::INSTALLATION_DIRECTORY, "lib/datetime/datetime")
require File.join(RuTils::INSTALLATION_DIRECTORY, "lib/transliteration")
require File.join(RuTils::INSTALLATION_DIRECTORY, "lib/countries/countries")

# Заглушка для подключения типографа (он теперь в отдельном геме)
require File.join(RuTils::INSTALLATION_DIRECTORY, "lib/gilenson/gilenson_stub")

# Оверлоады грузим только если константа не установлена в false
unless defined?(::RuTils::RUTILS_USE_DATE_HELPERS) && !::RuTils::RUTILS_USE_DATE_HELPERS
  require File.join(RuTils::INSTALLATION_DIRECTORY, "lib", "integration", "integration")
end
