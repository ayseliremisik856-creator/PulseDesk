class BrandsController < ApplicationController
  def create
    brand = Brand.new(params.require(:brand).permit(:name, :sla_policy_id))
    if brand.save
      redirect_to root_path, notice: "Marka eklendi.", status: :see_other
    else
      redirect_to root_path, alert: brand.errors.full_messages.join(", "), status: :see_other
    end
  end

  def update
    brand = Brand.find(params[:id])
    if brand.update(params.require(:brand).permit(:sla_policy_id))
      redirect_to sla_policies_path, notice: "Markanın SLA bağlantısı güncellendi. Yeni taleplerde uygulanır.", status: :see_other
    else
      redirect_to sla_policies_path, alert: brand.errors.full_messages.join(", "), status: :see_other
    end
  end
end
