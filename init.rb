# -*- encoding: utf-8 -*- 
=begin
  Этот файл - заглушка для Rails-плагина. 
  Если поместить rutils/ в папку vendor/plugins/ вашего Rails-приложения, 
  RuTils будет автоматически загружен с включенным флагом <tt>RuTils::overrides = true</tt>.
  В ActionController::Base будет установлен пре-фильтр устанавливающий флаг <tt>overrides.</tt>
=end
require File.dirname(__FILE__) +  '/lib/rutils' unless defined?(RuTils)

RuTils::overrides = true
require File.dirname(__FILE__) + '/lib/integration/rails_pre_filter' 

def russan_gem_required?
  require 'action_pack/version'
  ma, mi, ti = ActionPack::VERSION::MAJOR, ActionPack::VERSION::MINOR, ActionPack::VERSION::TINY 
  return true if (ma >= 2 && mi >= 2 && ti >= 1)
  false
end

if russan_gem_required?
  STDERR.puts "RuTils: On this version of Rails use the `russian` gem for date helper overrides instead"
else
  require File.dirname(__FILE__) + "/lib/integration/rails_date_helper_override"
end

# textilize и markdown
::ActionController::Base.send(:helper, RuTils::Gilenson::Helper)