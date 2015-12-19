class DevicesController < ApplicationController
  def create
    server = Server.find(params[:server_id])
    @device = server.devices.new(device_params)
    @device.save
    redirect_to server_device_path(server, @device)
  end
  
  def index
    @devices = Device.all
  end
  
  def show
    @device = Device.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.siren { render siren: @device}
    end  
  end
  
  private
  def device_params
    params.require(:device).permit(:type, :name, :state)
  end
end
