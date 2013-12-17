class ProposalViewerController < ApplicationController

  def show
    render :text =>  Proposal.find(params[:id]).generate
  end

end
