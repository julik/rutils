if defined?(BlueCloth)
  class Object::BlueCloth < String  #:nodoc:
    alias_method :old_to_html, :to_html
    def to_html(*opts)
      RuTils::overrides_enabled? ? RuTils::Gilenson::Formatter.new(old_to_html(*opts)).to_html : old_to_html(*opts)
    end
  end
end