class ProposalViewerController < ApplicationController

  def show
    render :text => File.open('public/proposal-template/index.html').read
  end

end
