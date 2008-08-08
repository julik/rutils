# Интеграция с BlueCloth - Markdown
# Сам Markdown никакой обработки типографики не производит (это делает RubyPants, но вряд ли его кто-то юзает на практике)
class MarkdownIntegrationTest < Test::Unit::TestCase
  def test_integration_markdown
    raise "You must have BlueCloth to test Markdown integration" and return if $skip_bluecloth

    RuTils::overrides = true
    assert RuTils.overrides_enabled?
    assert_equal "<p>И вот&#160;&#171;они пошли туда&#187;, и&#160;шли шли&#160;шли</p>", 
      BlueCloth.new('И вот "они пошли туда", и шли шли шли').to_html

    RuTils::overrides = false
    assert !RuTils.overrides_enabled?
    assert_equal "<p>И вот \"они пошли туда\", и шли шли шли</p>", 
      BlueCloth.new('И вот "они пошли туда", и шли шли шли').to_html
  end
end