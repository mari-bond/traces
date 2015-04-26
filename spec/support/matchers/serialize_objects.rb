RSpec::Matchers.define :serialize_objects do |objects|
  match do |response|
    ActiveModel::ArraySerializer.new(objects, { each_serializer: @serializer_klass }).to_json == response.to_json
  end

  chain :with do |serializer_klass|
    @serializer_klass = serializer_klass
  end
end