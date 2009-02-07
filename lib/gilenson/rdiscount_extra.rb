# -*- encoding: utf-8 -*- 
# RDiscount с поддержкой Gilenson
class RuTils::Gilenson::RDiscountExtra < RDiscount
  def to_html(*opts)
    RuTils::Gilenson::Formatter.new(super(*opts)).to_html
  end
end