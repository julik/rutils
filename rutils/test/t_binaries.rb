$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'


class RutilizeTest < Test::Unit::TestCase
  def setup
    @dirs = [
      '/tmp/app',
      '/tmp/notapp',
      '/tmp/app/vendor',
    ]
    @dirs.each{|dir|  Dir::mkdir(dir) }
    @rutilize = File.dirname(__FILE__) + '/../bin/rutilize'
  end
  
  def test_rutilize_app
    `#{@rutilize} #{@dirs[0]}`
    assert File.exist?(@dirs[0] + '/vendor/plugins/rutils')
    assert File.exist?(@dirs[0] + '/vendor/plugins/rutils/lib/rutils.rb')
  end
    
  def teardown
    @dirs.each {|dir|  `rm -rf #{dir}` }
  end
end