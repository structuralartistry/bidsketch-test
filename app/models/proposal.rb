class Proposal < ActiveRecord::Base
  belongs_to :client
  has_many :proposal_sections, :dependent => :destroy

  def generate
    template = File.open('public/proposal-template/index.html').read

    # merge top level fields
    merge_data = model_to_merge_fields
    merge_data.keys.each do |merge_field|
      template.gsub!(/\{#{merge_field}\}/, merge_data[merge_field])
    end

    # generate/merge the proposal sections
    template = merge_proposal_sections(template)

    template
  end

  private

    def merge_proposal_sections(template)
      section_template_matcher = /<!-- Populate and repeat this HTML for each proposal section -->.*<!-- end repeat -->/m
      template.match(section_template_matcher)
      section_template = $&
      merged_section_html = ''

      proposal_sections.each do |section|
        merged_section_html += generate_proposal_section(section, section_template)
      end
      template.gsub!(section_template_matcher, merged_section_html)

      template
    end

    def generate_proposal_section(section_data, section_template)
      section_template = section_template.dup
      section_template.gsub!(/\{section_header\}/, section_data.name)
      section_template.gsub!(/\{section_content\}/, section_data.description)

      section_template
    end

    def model_to_merge_fields
      { 'client_name' => client.name,
        'proposal_name' => name,
        'proposal_send_date' => send_date.to_s,
        'proposal_user_name' => user_name,
        'proposal_client_name' => client.name,
        'client_company' => client.company,
        'client_website' => client.website }
    end

end
