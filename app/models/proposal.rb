class Proposal < ActiveRecord::Base
  belongs_to :client
  has_many :proposal_sections, :dependent => :destroy

  def generate
    template = File.open('public/proposal-template/index.html').read

#    section_mapping = {
#      'client_name' => client.name,
#      'proposal_name' => name,
#      'proposal_send_date' => send_date,
#      '
#    }

    template.gsub!(/\{client_name\}/, client.name)
    template.gsub!(/\{proposal_name\}/, name)

    template.gsub!(/\{proposal_send_date\}/, send_date.to_s)

    template.gsub!(/\{proposal_user_name\}/, user_name)

    template.gsub!(/\{proposal_client_name\}/, client.name)

    template.gsub!(/\{client_company\}/, client.company)

    template.gsub!(/\{client_website\}/, client.website)

    section_template_matcher = /<!-- Populate and repeat this HTML for each proposal section -->.*<!-- end repeat -->/m
    template.match(section_template_matcher)
    section_template = $&
    merged_section_html = ''

    proposal_sections.each do |section|
      section_html = section_template
      section_html.gsub!(/\{section_header\}/, section.name)
      section_html.gsub!(/\{section_content\}/, section.description)

      merged_section_html += section_html
    end
    template.gsub!(section_template_matcher, merged_section_html)

    template
  end

end
