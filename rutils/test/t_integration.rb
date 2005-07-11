$KCODE = 'u'
require 'test/unit'
require 'rubygems'

require_gem 'RedCloth'
require_gem 'BlueCloth'


require File.dirname(__FILE__) + '/../lib/rutils'
# Весь integration надо грузить после патчимых пакетов
load File.dirname(__FILE__) + '/../lib/integration/integration.rb'

# Интеграция с RedCloth - Textile.
# Нужно иметь в виду что Textile осуществляет свою обработку типографики, которую мы подменяем!
class TextileIntegrationTest < Test::Unit::TestCase	
	def test_integration_textile		
		assert_equal "<p>И&nbsp;вот &laquo;они пошли туда&raquo;, и&nbsp;шли шли&nbsp;шли</p>", 
			RedCloth.new('И вот "они пошли туда", и шли шли шли').to_html
	end
end

# Интеграция с BlueCloth - Markdown
# Сам Markdown никакой обработки типографики не производит (это делает RubyPants, но вряд ли его кто-то юзает на практике)
class MarkdownIntegrationTest < Test::Unit::TestCase
	def test_integration_markdown
		assert_equal "<p>И вот&nbsp;&laquo;они пошли туда&raquo;, и&nbsp;шли шли&nbsp;шли</p>", 
			BlueCloth.new('И вот "они пошли туда", и шли шли шли').to_html
	end
end