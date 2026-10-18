class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show update]

  def index
    @tickets = Ticket.includes(:brand, :agent).order(created_at: :desc)
    @counts = Ticket.group(:status).count
    @overdue_count = @tickets.count { |ticket| ticket.sla.overdue? }
    @brands = Brand.order(:name)
    @agents = Agent.order(:name)
  end

  def new
    @ticket = Ticket.new
    load_options
  end

  def create
    @ticket = Ticket.new(params.require(:ticket).permit(:subject, :description, :customer_name, :customer_email, :priority, :brand_id))
    if @ticket.save
      redirect_to @ticket, notice: "Talep oluşturuldu. İlk yanıt için SLA başladı."
    else
      load_options
      render :new, status: :unprocessable_entity
    end
  end

  def show
    load_options
    @response = TicketResponse.new
  end

  def update
    if @ticket.update(params.require(:ticket).permit(:agent_id, :status))
      redirect_to @ticket, notice: "Talep güncellendi.", status: :see_other
    else
      load_options
      @response = TicketResponse.new
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def load_options
    @brands = Brand.order(:name)
    @agents = Agent.order(:name)
  end
end
