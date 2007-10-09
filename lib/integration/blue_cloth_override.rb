if defined?(BlueCloth) && !BlueCloth.instance_methods.include?("to_html_without_rutils")
  class Object::BlueCloth < String  #:nodoc:
    alias_method :to_html_without_rutils, :to_html
    def to_html(*opts)
      if RuTils::overrides_enabled?
        RuTils::Gilenson::Formatter.new(to_html_without_rutils(*opts)).to_html
      else
        to_html_without_rutils(*opts)
      end
    end
  end
end