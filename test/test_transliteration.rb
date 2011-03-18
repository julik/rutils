# -*- encoding: utf-8 -*- 
$KCODE = 'u' if RUBY_VERSION < '1.9.0'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__)) + '/../lib/rutils'


class TranslitTest < Test::Unit::TestCase

  def setup
    @string = "Это кусок строки русских букв v peremeshku s latinizey i амперсандом (pozor!) & something"
  end

  def test_translify
    assert_equal "Eto kusok stroki russkih bukv v peremeshku s latinizey i ampersandom (pozor!) & something", @string.translify
  end
  
  def test_dirify
    assert_equal "eto-kusok-stroki-russkih-bukv-v-peremeshku-s-latinizey-i-ampersandom-pozor-and-something", @string.dirify
    assert_equal "esche-russkiy-tekst", "Еще РусСКий теКст".dirify
    assert_equal "kooperator-poobedal-offlayn", "кооператор  пообедал  оффлайн".dirify, "dirify не должен съедать парные буквы"
  end  
end