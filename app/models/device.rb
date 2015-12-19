require 'oat/adapters/siren'

class Device < ActiveRecord::Base
  self.inheritance_column = 'column_that_is_not_type'
  belongs_to :server
  
  def to_siren
    DeviceSerializer.new(self).to_siren
  end
end

class DeviceSerializer < Oat::Serializer
  adapter Oat::Adapters::Siren

  schema do
    type ['device', item.type]
    property :name, item.name
    property :type, item.type
    property :state, item.state
  end

  def to_siren
    to_json
  end
end