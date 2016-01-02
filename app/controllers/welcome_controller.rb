class WelcomeController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.zetta {
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

        links = []
        links << [:self, {href: root_url}]
        @servers = Server.all
        @servers.each do |server|
          links << [['http://rels.zettajs.io/server', 'http://rels.zettajs.io/peer'], {title: server.name, href: server_url(server)}]
        end
        actions = []
        actions << {
          name: :'query-devices',
          class: 'transition',
          href: root_url,
          method: 'GET',
          type: 'application/x-www-form-urlencoded',
          fields: [
            {name: :server, type: :text},
            {name: :ql, type: :text}
          ]
        }
        render zetta: self,
          links: links,
          actions: actions,
          class: ['root']
      }
    end
  end
end
