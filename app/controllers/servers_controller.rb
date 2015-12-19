class ServersController < ApplicationController
  def create
    @server = Server.new(server_params)
    @server.save
    redirect_to @server
  end
  
  def show
    @server = Server.find(params[:id])
  end

  private
  def server_params
    params.require(:server).permit(:name)
  end

end
