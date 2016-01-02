class ServersController < ApplicationController
  def create
    @server = Server.new(server_params)
    @server.save
    redirect_to @server
  end
  
  def show
    @server = Server.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.zetta {
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
        links = []
        links << [:self, {href: server_url(@server)}]
        @devices = @server.devices
        @devices.each do |server|
        end
        actions = []
        actions << {
          name: :'query-devices',
          class: 'transition',
            href: server_url(@server),
            method: 'GET',
            type: 'application/x-www-form-urlencoded',
            fields: [
              {name: :server, type: :text},
              {name: :ql, type: :text}
            ]
        }
        # TODO: create three serializers: root, server and device
        entities = {}
        entities[:devices] = []
        entities[:devices] << {
          
        }
        render zetta: @server,
          links: links,
          actions: actions,
          properties: @server.attribute_names,
          entities: entities,
          class: ['server']
      }
    end
  end

  private
  def server_params
    params.require(:server).permit(:name)
  end

end
