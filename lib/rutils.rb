# -*- encoding: utf-8 -*- 
$KCODE = 'u'

require File.dirname(__FILE__) + '/version'

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
    Thread.current[:rutils_overrided_enabled] = (new_override_flag ? true : false)
  end
  module_function :overrides=
  
  def self.thread_local_or_own_flag #:nodoc:
    Thread.current.keys.include?(:rutils_overrided_enabled) ? Thread.current[:rutils_overrided_enabled] : false
  end
  
  def self.load_component(name) #:nodoc:
    require File.join(RuTils::INSTALLATION_DIRECTORY, "lib", name.to_s, name.to_s)
  end
end

[:pluralizer, :gilenson, :datetime, :transliteration, :integration, :countries].each do | submodule |
  require File.join(RuTils::INSTALLATION_DIRECTORY, "lib", submodule.to_s, submodule.to_s)
end