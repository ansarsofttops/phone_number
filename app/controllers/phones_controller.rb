class PhonesController < ApplicationController

  def index
    render json: {phones: Phone.pluck(:phone)}, status: :ok
  end

  def create
    phone = Phone.new(phone_params)
    if phone.save
      render json: {phone: phone.phone}, status: :ok
    else
      render json: phone.errors, status: :unprocessable_entity
    end
  end

  private

  def phone_params
    params.require(:phone).permit!
  end
end
