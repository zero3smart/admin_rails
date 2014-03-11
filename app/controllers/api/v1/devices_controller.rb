class Api::V1::DevicesController < Api::V1::AuthenticatedController
  skip_before_action :authenticate_user_from_token!, only: :change_language
  def create
    # Find if device token exists for another user
    device = Device.where("token = ? and user_id != ?", params[:device][:token], current_user.id).first

    # If device exists and has different user_id destroy it
    device.update token: nil if device

    # If I have device registered just return 200
    if current_user.devices.exists?(token: params[:device][:token])
      render json: {}, status: 200
      return
    end

    # If device is not registered -> register it to my user_id
    if device = current_user.devices.first.update(device_params)
      render json: device
    else
      render json: { error_info: { code: 101, message: device.errors.full_message.join(", ") } }, status: 400
    end
  end

  def change_language
    device = Device.where(phone: params[:phone]).first
    if device
      render json: {}, status: 200 if device.update language: params[:language]
    else
      render json: { error_info: { code: 115, message: t('errors.device_not_exists') } }, status: 400
    end
  end

  private

  def device_params
    params.require(:device).permit(:token)
  end
end

