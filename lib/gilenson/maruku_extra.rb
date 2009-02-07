# -*- encoding: utf-8 -*- 
# Maruku с поддержкой Gilenson
class RuTils::Gilenson::MarukuExtra < Maruku
  def to_html(*opts)
    RuTils::Gilenson::Formatter.new(super(*opts)).to_html
  end
end