require 'test_helper'

class ProposalGenerationTest < ActionController::IntegrationTest

  test 'something' do
    get '/proposal_viewer/show/1'

    assert(response.body.include?('Hello!'))
  end

end
