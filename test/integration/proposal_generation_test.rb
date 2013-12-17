require 'test_helper'

class ProposalGenerationTest < ActionController::IntegrationTest

  test 'it returns the expected template' do
    get '/proposal_viewer/show/1'

    assert_match(/<h2 id="project_name">/, response.body)
  end

  test 'it merges the data' do
    client = Client.create( :name => 'Dakmali Karuna',
                            :company => 'StructuralArtistry',
                            :website => 'structuralartistry.com')

    proposal = Proposal.create( :name => 'DK First Proposal',
                                :user_name => 'Joselyn Smith',
                                :send_date => Date.today,
                                :client_id => client.id )

    proposal_sections = []
    ProposalSection.create( :name => 'Section One',
                            :description => 'The biggest deal',
                            :proposal_id => proposal.id )

    get '/proposal_viewer/show/1'

	  assert_match(/<h1 id="client_name">#{client.name}/, response.body)
  end

end
