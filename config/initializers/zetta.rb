require 'oat/adapters/siren'
class ZettaSerializer < Oat::Serializer
  adapter Oat::Adapters::Siren

  schema do
    type *context[:class]
    # TODO: fix the nested array on rel: [[up:, 'http://...']]
    context[:links].each do |l| 
      # link :self, :href => url_for(item.id)
      link *l
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