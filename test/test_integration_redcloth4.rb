# Интеграция с RedCloth - Textile.
# Нужно иметь в виду что Textile осуществляет свою обработку типографики, которую мы подменяем!
class Redcloth4IntegrationTest < Test::Unit::TestCase
  def test_integration_textile
    raise "You must have RedCloth to test Textile integration" and return if $skip_redcloth
    
    RuTils::overrides = true
    assert RuTils.overrides_enabled?
    
    assert_equal "<p>И вот&#160;&#171;они пошли туда&#187;, и&#160;шли шли&#160;шли</p>", 
      RedCloth.new('И вот "они пошли туда", и шли шли шли').to_html
    
    RuTils::overrides = false      
    assert !RuTils::overrides_enabled?
    assert_equal '<p><strong>strong text</strong> and <em>emphasized text</em></p>',
      RedCloth.new("*strong text* and _emphasized text_").to_html, 
        "Spaces should be preserved without RuTils"
    
    RuTils::overrides = true      
    assert RuTils.overrides_enabled?
    assert_equal '<p><strong>strong text</strong> and&#160;<em>emphasized text</em></p>',
      RedCloth.new("*strong text* and _emphasized text_").to_html,
        "Spaces should be preserved"
    
    RuTils::overrides = false
    assert !RuTils.overrides_enabled?
    assert_equal "<p>И вот &#8220;они пошли туда&#8221;, и шли шли шли</p>", 
      RedCloth.new('И вот "они пошли туда", и шли шли шли').to_html
  
  end
end