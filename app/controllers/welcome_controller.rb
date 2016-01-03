class WelcomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.zetta { render zetta: Server.all, controller: self }
    end
  end
end
