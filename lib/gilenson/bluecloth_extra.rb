# BlueCloth с поддержкой Gilenson
class RuTils::Gilenson::BlueClothExtra < BlueCloth
  def to_html(*opts)
    if RuTils::overrides_enabled?
      RuTils::Gilenson::Formatter.new(super(*opts)).to_html
    else
      super(*opts)
    end
  end
end