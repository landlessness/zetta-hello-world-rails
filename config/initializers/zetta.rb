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
    actions device, device_controller
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
  
  def actions(device, device_controller)
    device.state_transitions.each do |state_transition|
      action state_transition.event do |action|
        action.class 'transition'
        action.href device_controller.server_device_url(device.server, device)
        action.method 'POST'
        action.field :action do |f|
          f.type :hidden
          f.value state_transition.event
        end
        device.class.instance_method(state_transition.event).parameters.each do |parameter|
          if (:req == parameter.first || :opt == parameter.first)
            action.field parameter[1].to_sym do |f|
              f.type :text
            end
          end
        end
      end
    end
  end
  
  def properties(device)
    map_properties *device.attribute_names
  end

end


ActionController::Renderers.add :zetta do |resource, options|
  self.content_type ||= Mime[:zetta]
  DeviceSerializer.new(resource, options).as_zetta(options)
end