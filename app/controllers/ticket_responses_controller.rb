class TicketResponsesController < ApplicationController
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @response = @ticket.ticket_responses.build(params.require(:ticket_response).permit(:body, :author_type))
    if @response.save
      redirect_to @ticket, notice: "Yanıt eklendi.", status: :see_other
    else
      @agents = Agent.order(:name)
      @brands = Brand.order(:name)
      render "tickets/show", status: :unprocessable_entity
    end
  end
end
