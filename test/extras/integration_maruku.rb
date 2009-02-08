# -*- encoding: utf-8 -*- 
require 'maruku'

# Интеграция с BlueCloth - Markdown
# Сам Markdown никакой обработки типографики не производит (это делает RubyPants, но вряд ли его кто-то юзает на практике)
class MarukuIntegrationTest < Test::Unit::TestCase
  C = RuTils::Gilenson::MarukuExtra
  
  def test_integration_maruku
    
    assert_equal "<p>И вот&#160;&#171;они пошли туда&#187;, и&#160;шли шли&#160;шли</p>", 
      C.new('И вот "они пошли туда", и шли шли шли').to_html
    
  end
end