require 'test_helper'

class ProposalGenerationTest < ActionController::IntegrationTest
  fixtures :clients, :proposals, :proposal_sections

  test 'it returns the expected template' do
    proposal = proposals(:proposal_one)

    get "/proposal_viewer/show/#{proposal.id}"

    assert_match(/<title>Professional Template<\/title>/, response.body)
  end

  test 'it merges the data' do
    proposal = proposals(:proposal_one)
    client = proposal.client

    get "/proposal_viewer/show/#{proposal.id}"

	  assert_match(/#{client.name}/, response.body)
  end

end
