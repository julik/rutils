=begin
  Этот файл - заглушка для Rails-плагина. Если поместить rutils в папку vendor/plugins RuTils будет
  автоматически вгружен в ваше Rails-приложение
=end
require File.join(File.dirname(__FILE__), 'lib', 'rutils')
RuTils::overrides = true