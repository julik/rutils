# RedCloth 4
class RedCloth::TextileDoc < String
  alias_method  :to_html_without_rutils, :to_html
  
  def to_html
    if RuTils::overrides_enabled?
      suspended = to_html_without_rutils
      
      # Return quotes to original state
      [187, 171, 8220, 8221].map do |e| 
        suspended.gsub! /&\##{e};/, '"'
      end
      
      # Return spaces to original state
      [160].map do |e| 
        suspended.gsub! /&\##{e};/, ' '
      end
      
      suspended.gilensize
    else
      to_html_without_rutils
    end
  end
end