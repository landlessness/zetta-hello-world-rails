ActionController::Renderers.add :siren do |resource, options|
  self.content_type ||= Mime[:siren]
  resource.to_siren
end

ActionController::Renderers.add :zetta do |resource, options|
  self.content_type ||= Mime[:zetta]
  resource.to_zetta
end