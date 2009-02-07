# -*- encoding: utf-8 -*- 
# Включается на правах хелпера в Rails-приложение
module RuTils::Gilenson::Helper

  # Возвращает текст обработанный Гиленсоном
  def gilensize(text, options = {})
    return "" if text.blank?
    f = RuTils::Gilenson::Formatter.new
    f.configure!(options)
    f.process(text)
  end
  
  # Возвращает текст обработанный Текстилем и Гиленсоном
  # <i>Метод доступен только при включенном RedCloth</i>
  def textilize(text)
    return "" if text.blank?
    if RuTils.overrides_enabled?
      RuTils::Gilenson::RedClothExtra.new(text, [ :hard_breaks ]).to_html
    else
      super(text)
    end
  end
  
  # Возвращает текст с кодом Markdown превращенным в HTML, попутно обработанный Гиленсоном
  # <i>Метод доступен только при наличии BlueCloth</i>.
  def markdown(text)
    return "" if text.blank?
    if RuTils.overrides_enabled?
      RuTils::Gilenson::BlueClothExtra.new(text).to_html
    else
      super(text)
    end
  end
end