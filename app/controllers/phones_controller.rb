class PhonesController < ApplicationController

  def index
    render json: { phones: Phone.pluck(:phone) }, status: :ok
  end

  def create
    phone = Phone.new(number: params[:number])
    if phone.save
      render json: {phone: phone.number}, status: :ok
    else
      render json: phone.errors, status: :unprocessable_entity
    end
  end
end
