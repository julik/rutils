# -*- encoding: utf-8 -*- 
$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'


class PropisjuTestCase < Test::Unit::TestCase
  def test_ints
    assert_equal "пятьсот двадцать три", 523.propisju
    assert_equal "шесть тысяч семьсот двадцать семь", 6727.propisju
    assert_equal "восемь миллионов шестьсот пятьдесят два", 8000652.propisju
    assert_equal "восемь миллионов шестьсот пятьдесят две", 8000652.propisju(2)
    assert_equal "восемь миллионов шестьсот пятьдесят два", 8000652.propisju(3)
    assert_equal "сорок пять", 45.propisju
    assert_equal "пять", 5.propisju
    assert_equal "шестьсот двенадцать", 612.propisju
    assert_equal "двадцать пять колес", 25.propisju_items(3, "колесо", "колеса", "колес")
    assert_equal "двадцать одна подстава", 21.propisju_items(2, "подстава", "подставы", "подстав")    
  end
  
  def test_floats
    assert_equal "шесть целых пять десятых", (6.50).propisju
    assert_equal "триста сорок одна целая девять десятых", (341.9).propisju
    assert_equal "триста сорок одна целая двести сорок пять тысячных", (341.245).propisju
    assert_equal "двести три целых сорок одна сотая", (203.41).propisju
    assert_equal "четыреста сорок две целых пять десятых", (442.50000).propisju
    assert_equal "двести двенадцать целых четыре десятых сволочи", (212.40).propisju_items(2, "сволочь", "сволочи", "сволочей")
    assert_equal "двести двенадцать сволочей", (212.00).propisju_items(2, "сволочь", "сволочи", "сволочей")
  end
  
  def test_items
    assert_equal "чемодана", 523.items("чемодан", "чемодана", "чемоданов")
    assert_equal "партий", 6727.items("партия", "партии", "партий")
    assert_equal "козлов", 45.items("козел", "козла", "козлов")
    assert_equal "колес", 260.items("колесо", "колеса", "колес")
  end
  
  def test_rublej
    assert_equal "сто двадцать три рубля", 123.rublej
    assert_equal "триста сорок три рубля двадцать копеек", (343.20).rublej
    assert_equal "сорок две копейки", (0.4187).rublej
    assert_equal "триста тридцать два рубля", (331.995).rublej
    assert_equal "один рубль", 1.rubl
    assert_equal "три рубля четырнадцать копеек", (3.14).rublja
  end
  
  def test_kopeek
    assert_equal "сто двадцать три рубля", 12300.kopeek
    assert_equal "три рубля четырнадцать копеек", 314.kopeek
    assert_equal "тридцать две копейки", 32.kopeek
    assert_equal "двадцать одна копейка", 21.kopeika
    assert_equal "три копейки", 3.kopeiki
  end
  
  def test_kopeek_should_not_be_available_on_floats
    assert_raise(NoMethodError) { (3.3).kopeek }
  end
end

#class PluralizeTestCase < Test::Unit::TestCase
#
#  def test_males
#    assert_equal "гада", "гад".ru_pluralize(3)
#    assert_equal "враг", "враг".ru_pluralize(1)
#    assert_equal "сцепа", "сцеп".ru_pluralize(2)
#    assert_equal "огня", "огонь".ru_pluralize(2)
#    assert_equal "огней", "огонь".ru_pluralize(6)
#  end
#
#  def test_females
#    assert_equal "сволочей", "сволочь".ru_pluralize(6)
#    assert_equal "весны", "весна".ru_pluralize(3)
#    assert_equal "чета", "четы".ru_pluralize(2)
#    assert_equal "чета", "чет".ru_pluralize(5)
#    assert_equal "вони", "вонь".ru_pluralize(3)
#    assert_equal "воней", "вонь".ru_pluralize(6)
#  end
#      
#  def test_middles
#    assert_equal "окна", "окно".ru_pluralize(2)
#    assert_equal "колес", "колесо".ru_pluralize(15)
#    assert_equal "насилий", "насилие".ru_pluralize(5)
#  end      
#end