class DevicesController < ApplicationController
  def create
    server = Server.find(params[:server_id])
    @device = server.devices.new(device_params)
    @device.save
    redirect_to @device
  end
  
  def index
    @devices = Device.all
  end
  
  def show
    @device = Device.find(params[:id])
  end
  
  private
  def device_params
    params.require(:device).permit(:type, :name, :state)
  end
end
