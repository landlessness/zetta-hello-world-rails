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
      format.zetta { render zetta: @server, controller: self }
    end
  end

  private
  def server_params
    params.require(:server).permit(:name)
  end

end
