require 'oat/adapters/siren'

# TODO: create three serializers: root, server and device

class ZettaSerializer < Oat::Serializer
  adapter Oat::Adapters::Siren
  
  attr_reader :item_controller

  def initialize(item, context = {}, _adapter_class = nil, parent_serializer = nil)
    @item_controller = context[:controller]
    super
  end

  def as_zetta(options)
    to_json
  end

  protected
  
  def assign_links
    link :self, 
      href: item_controller.url_for(item)
  end

  def assign_schema
    assign_types
    assign_links
    assign_actions
    assign_entities
    assign_properties
  end

  def assign_properties
    map_properties *item.attribute_names
  end

  def assign_types
    type item.class.name.underscore
  end

  def assign_actions(href = item_controller.server_url(item))
    action :'query-devices' do |action|
      action.class 'transition'
      action.href href
      action.method 'GET'
      action.type 'application/x-www-form-urlencoded'
      action.field :ql do |f|
        f.type :text
      end
      action.field :server do |f|
        f.type :text
      end
    end
  end

  def assign_entities
    # optionally defined by subclasses
  end

  def rels_url(rels_type)
    'http://rels.zettaapi.org/' + rels_type
  end

end

class RootSerializer < ZettaSerializer
  schema do
    assign_schema
  end

  protected

  def assign_types
    type 'root'
  end

  def assign_links
    link :self,
      href: item_controller.root_url
    item.each do |server|
      link rels_url('server'),
        title: server.name.to_sym,
        href: item_controller.url_for(server)
    end
  end
  
  def assign_properties
    # no op
  end
  
  def assign_actions
    super(item_controller.root_url)
  end
  
end

class ServerSerializer < ZettaSerializer

  schema do
    assign_schema
  end

  protected
  
  def assign_entities
    entities :devices, item.devices, DeviceSerializer, {controller: item_controller}
  end
  
end

class DeviceSerializer < ZettaSerializer

  schema do
    assign_schema
  end
  
  protected
  
  def assign_types
    type item.class.name.underscore, item.type
  end
  
  def assign_links
    link :self,
      href: item_controller.url_for([item.server, item])
    link [:up, rels_url('server')], 
      href: item_controller.url_for(item.server),
      title: item.server.name
  end
  
  def assign_actions
    item.state_transitions.each do |state_transition|
      action state_transition.event do |action|
        action.class 'transition'
        action.href item_controller.server_device_url(item.server, item)
        action.method 'POST'
        action.field :action do |f|
          f.type :hidden
          f.value state_transition.event
        end
        item.class.instance_method(state_transition.event).parameters.each do |parameter|
          if (:req == parameter.first || :opt == parameter.first)
            action.field parameter[1].to_sym do |f|
              f.type :text
            end
          end
        end
      end
    end
  end
end

ActionController::Renderers.add :zetta do |resource, options|
  self.content_type ||= Mime[:zetta]
  
  case resource
  when Device
    DeviceSerializer.new(resource, options).as_zetta(options)
  when Server
    ServerSerializer.new(resource, options).as_zetta(options)
  when Server::ActiveRecord_Relation
    RootSerializer.new(resource, options).as_zetta(options)
  end
end