if defined?(Object::RedCloth) && !RedCloth.instance_methods.include?(:htmlesc_without_rutils)
  if RedCloth.class == Module
    require File.dirname(__FILE__) + '/red_cloth_four'
  else 
    require File.dirname(__FILE__) + '/red_cloth_three'
  end 
end