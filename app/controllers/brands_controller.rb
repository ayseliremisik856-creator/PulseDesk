class BrandsController < ApplicationController
  def create
    brand = Brand.new(params.require(:brand).permit(:name))
    if brand.save
      redirect_to root_path, notice: "Marka eklendi.", status: :see_other
    else
      redirect_to root_path, alert: brand.errors.full_messages.join(", "), status: :see_other
    end
  end
end
