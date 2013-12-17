require 'test_helper'
# prefer nokigiri but have to search for for rails 2x
require 'hpricot'

class ProposalTest < ActiveSupport::TestCase
  fixtures :clients, :proposals, :proposal_sections

  test 'it merges the model data with the template' do
    proposal = proposals(:proposal_one)
    proposal.proposal_sections << proposal_sections(:proposal_section_two)
    proposal.proposal_sections << proposal_sections(:proposal_section_three)

    client = proposal.client

    output = proposal.generate
    doc = Hpricot(output)

    assert_equal(doc.search('#client_name').html, client.name)
    assert_equal(doc.search('#project_name').html, proposal.name)
    assert_equal(doc.search('#sent_date').html, proposal.send_date.to_s)
    assert_equal(doc.search('#my_name').html, proposal.user_name)
    assert_equal(doc.search('#client_contact_name').html, proposal.client.name)
    company_info = doc.search('#my_company')
    assert_equal(company_info.search('h1').html, proposal.client.company)
    assert_equal(company_info.search('div').html, proposal.client.website)

    assert(proposal.proposal_sections.count == 3) # reality check
    proposal.proposal_sections.each do |section|
      assert(doc.search('#proposal-content').search("h1[text()='#{section.name}']").html.strip != '')
      assert(doc.search('#proposal-content').search("div[text()='#{section.description}']").html.strip != '')
    end
  end

end
