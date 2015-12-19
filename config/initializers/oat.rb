Mime::Type.register 'application/vnd.siren+json', :siren

ActionController::Renderers.add :siren do |resource, options|
  self.content_type ||= Mime[:siren]
  resource.to_siren
end