# -*- encoding: utf-8 -*- 
class ActionController::Base
  before_filter { RuTils::overrides = true }
end