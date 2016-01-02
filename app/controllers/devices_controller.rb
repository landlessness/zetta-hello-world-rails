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
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
        links = []
        links << [:self, {href: server_device_url(@device.server, @device)}]
        links << [[:up, 'http://rels.zettaapi.org/server'], {href: server_url(@device.server), title: @device.server.name}]
        actions = []
        @device.state_transitions.each do |state_transition|
          fields = [{
            name: :action,
            type: :hidden,
            value: state_transition.event
          }]
          Device.instance_method(state_transition.event).parameters.each do |parameter|
            if (:req == parameter.first || :opt == parameter.first)
              fields << {
                name: parameter[1],
                type: :text
              }
            end
          end
          actions << {
            name: state_transition.event,
            class: 'transition',
            href: server_device_url(@device.server, @device),
            method: 'POST',
            fields: fields
          }
        end
        render zetta: @device,
          links: links,
          actions: actions,
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
