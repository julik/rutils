# -*- encoding: utf-8 -*- 
$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'

class RutilsBaseTest < Test::Unit::TestCase
  def test_rutils_location
    libdir = File.expand_path(File.dirname(__FILE__) + '/../')
    assert_equal libdir, RuTils::INSTALLATION_DIRECTORY
  end
end