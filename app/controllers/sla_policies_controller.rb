class SlaPoliciesController < ApplicationController
  def index
    load_records
    @policy = SlaPolicy.new(first_response_minutes: FirstResponseSla::DEFAULT_TARGET_MINUTES)
  end

  def create
    @policy = SlaPolicy.new(policy_params)
    if @policy.save
      redirect_to sla_policies_path, notice: "Ortak SLA politikası oluşturuldu.", status: :see_other
    else
      load_records
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @policy = SlaPolicy.find(params[:id])
    if @policy.update(policy_params)
      redirect_to sla_policies_path, notice: "Politika güncellendi. Bağlı tüm markaların yeni talepleri yeni hedefi kullanır.", status: :see_other
    else
      load_records
      render :index, status: :unprocessable_entity
    end
  end

  private

  def policy_params
    params.require(:sla_policy).permit(:name, :first_response_minutes)
  end

  def load_records
    @policies = SlaPolicy.includes(:brands).order(:name)
    @brands = Brand.includes(:sla_policy).order(:name)
  end
end
