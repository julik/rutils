module RuTils
  @@overrides = true
  
  # Метод позволяет проверить, включена ли перегрузка функций других модулей.
  # Попутно он спрашивает модуль Locale (если таковой имеется) является ли русский
  # текущим языком, и если является, включает перегрузку функций имплицитно.
  # Это позволяет подчинить настройку перегруженных функций настроенной локали.
  # Модуль Locale можно получить как часть Multilingual Rails, как часть Ruby-Gettext или как отдельный
  # модуль ruby-locale. Мы поддерживаем все три.
  def self.overrides_enabled?
    if defined?(Locale) and Locale.respond_to?(:current)
      return true if Locale.current.to_s.split('_').first == 'ru'
    end
    @@overrides ? true : false
  end

  # Включает или выключает перегрузки других модулей. Полезно, например, в случае когда нужно рендерить страницу
  # сайта на нескольких языках и нужно отключить русское оформление текста для других языков.  
  def self.overrides= (new_override_flag)
    @@overrides = (new_override_flag ? true : false)
  end
  
  # Вновь выполняет перегрузку. Делать это надо после того, как в программу импортированы
  # другие модули.
  def self.reload_integrations!
    load File.dirname(__FILE__) + '/blue_cloth_override.rb'
    load File.dirname(__FILE__) + '/red_cloth_override.rb'
    load File.dirname(__FILE__) + '/rails_date_helper_override.rb'    
  end
end

RuTils::reload_integrations!