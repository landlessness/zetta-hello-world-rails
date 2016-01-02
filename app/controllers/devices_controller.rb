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
    logger.info device_params
    @device = Device.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.zetta {
        links = []
        links << [:self, {href: server_device_url(@device.server, @device)}]
        links << [[:up, 'http://rels.zettaapi.org/server'], {href: server_url(@device.server), title: @device.server.name}]
        render zetta: @device,
        links: links,
        class: ["device", @device.type],
        properties: @device.attribute_names
      }
    end  
  end
  
  private
  def device_params
    params.permit(:message, :type, :name, :state)
  end
end
