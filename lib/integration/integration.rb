module RuTils
  # Вновь выполняет перегрузку. Делать это надо после того, как в программу импортированы
  # другие модули.
  def self.reload_integrations!
    load File.dirname(__FILE__) + '/blue_cloth_override.rb'
    load File.dirname(__FILE__) + '/red_cloth_override.rb'
    load File.dirname(__FILE__) + '/rails_date_helper_override.rb'    
  end
end

RuTils::reload_integrations!