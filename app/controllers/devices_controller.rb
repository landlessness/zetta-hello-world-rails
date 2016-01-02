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
      format.zetta {
        # TODO: move headers outta here
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
        render zetta: @device, controller: self
      }
    end  
  end
  
  private
  def device_params
    params.permit(:message, :type, :name, :state)
  end
end
