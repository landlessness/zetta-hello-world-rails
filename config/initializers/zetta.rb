require 'oat/adapters/siren'

# TODO: create three serializers: root, server and device

class ZettaSerializer < Oat::Serializer
  adapter Oat::Adapters::Siren

  schema do
    type *context[:class]
    # TODO: fix the nested array on rel: [[up:, 'http://...']]
    context[:links].each do |l| 
      # link :self, :href => url_for(item.id)
      link *l
    end
    context[:actions].each do |a| 
      # link :self, :href => url_for(item.id)
      action a[:name].to_sym do |action|
        action.class a[:class]
        action.href a[:href]
        action.method a[:method]
        action.type a[:type] if a[:type]
        a[:fields].each do |field|
          action.field field[:name].to_sym do |f|
            f.type field[:type]
            f.value field[:value] if field[:value]
          end
        end
      end
    end
    map_properties *context[:properties]
  end
  
  def as_zetta(options)
    to_json
  end

end


ActionController::Renderers.add :zetta do |resource, options|
  self.content_type ||= Mime[:zetta]
  ZettaSerializer.new(resource, options).as_zetta(options)
end