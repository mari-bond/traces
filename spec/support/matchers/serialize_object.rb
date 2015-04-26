RSpec::Matchers.define :serialize_object do |object|
  match do |response|
    @serializer_klass.new(object, { root: false }).to_json == response.to_json
  end

  chain :with do |serializer_klass|
    @serializer_klass = serializer_klass
  end
end