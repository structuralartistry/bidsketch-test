require 'test_helper'

class ProposalTest < ActiveSupport::TestCase

  test 'it merges the model data with the template' do
    proposal = proposals(:proposal_one)
    client = proposal.client

    output = proposal.generate

    assert_match(/<h1 id="client_name">#{client.name}/, output)
    assert_match(/<h2 id="project_name">#{proposal.name}/, output)

    assert_match(/<td id="sent_date">#{proposal.send_date}/, output)

    assert_match(/<span id="my_name">#{proposal.user_name}/, output)

    assert_match(/<span id="client_contact_name">#{proposal.client.name}/, output)

    assert_match(/<h1 style="margin-bottom:8px">#{proposal.client.company}/, output)

    assert_match(/<div>#{proposal.client.website}/, output)

    assert(proposal.proposal_sections.count, 3) # reality check
    proposal.proposal_sections.each do |section|
      assert_match(/<h1> #{section.name}/, output)
      assert_match(/#{section.description}/, output)
    end
  end

end
