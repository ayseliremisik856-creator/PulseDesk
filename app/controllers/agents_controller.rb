class AgentsController < ApplicationController
  def create
    agent = Agent.new(params.require(:agent).permit(:name, :email))
    if agent.save
      redirect_to root_path, notice: "Ajan eklendi.", status: :see_other
    else
      redirect_to root_path, alert: agent.errors.full_messages.join(", "), status: :see_other
    end
  end
end
