ActionController::Routing::Routes.draw {  |map| map.connect ':controller/:action/:id' }
require 'action_controller/test_process'


class RutiledController < ActionController::Base #:nodoc:
  def overridden
    render :inline => '<%= Time.local(2008,8,8).strftime("%B") %>'
  end
  def rescue_action(e); raise e; end
end

class RailsFilterTest < Test::Unit::TestCase
  
  def setup
    @controller = RutiledController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_overrides_preserved_in_render
    get :overridden
    assert_response :success
    assert_equal "Август", @response.body
  end
end