=begin
  Этот файл - заглушка для Rails-плагина. 
  Если поместить rutils/ в папку vendor/plugins/ вашего Rails-приложения, 
  RuTils будет автоматически загружен с включенным флагом <tt>RuTils::overrides = true</tt>
=end
require File.join(File.dirname(__FILE__), 'lib', 'rutils')
RuTils::overrides = true
require File.dirname(__FILE__), + '/lib/rutils/rails_pre_filter' 