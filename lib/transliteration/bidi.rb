# -*- encoding: utf-8 -*- 
# ++DEPRECATED++ Этот модуль удален и присутствует только для выдачи сообщения об ошибке.
module RuTils::Transliteration::BiDi
  ERR = "Equivalent bidirectional transliteration for URLs is malpractive. BiDi translit has been removed from RuTils"
  
  extend self
  
  # ++DEPRECATED++ 
  def translify(str, allow_slashes = true)
    bail!
  end

  # ++DEPRECATED++ 
  def detranslify(str, allow_slashes = true)
    bail!
  end
  
  def bail! #:nodoc:
    raise RuTils::RemovedFeature, ERR
  end
end
