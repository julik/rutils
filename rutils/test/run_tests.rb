Dir.entries(File.dirname(__FILE__)).each do | it|
  next unless it =~ /^t_/
  require File.dirname(__FILE__) + '/' + it.gsub(/\.rb$/, '')
end