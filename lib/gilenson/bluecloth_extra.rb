# -*- encoding: utf-8 -*- 
# BlueCloth с поддержкой Gilenson
class RuTils::Gilenson::BlueClothExtra < BlueCloth
  def to_html(*opts)
    RuTils::Gilenson::Formatter.new(super(*opts)).to_html
  end
end