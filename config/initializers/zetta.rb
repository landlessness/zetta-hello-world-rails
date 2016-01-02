require 'oat/adapters/siren'

# TODO: create three serializers: root, server and device

class DeviceSerializer < Oat::Serializer
  adapter Oat::Adapters::Siren
  
  schema do
    device = item
    device_controller = context[:controller]
    
    # TODO: DRY this up. why do I keep repeating device? block?
    types device
    links device, device_controller
    properties device
  end
  
  def as_zetta(options)
    to_json
  end
  
  protected
  
  def types(device)
    type device.class.name.underscore, device.type
  end
  
  def links(device, device_controller)
    link :self, 
      href: device_controller.server_device_url(device.server, device)
    link [:up, 'http://rels.zettaapi.org/server'], 
      href: device_controller.server_url(device.server), 
      title: device.server.name
  end
  
  def properties(device)
    map_properties *device.attribute_names
  end

end


ActionController::Renderers.add :zetta do |resource, options|
  self.content_type ||= Mime[:zetta]
  DeviceSerializer.new(resource, options).as_zetta(options)
end