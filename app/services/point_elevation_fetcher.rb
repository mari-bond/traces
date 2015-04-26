class PointElevationFetcher
  def initialize(data)
    if data.kind_of?(Array)
      @points = data
    else
      @point = data
    end
  end

  def fetch
    return unless @point || @points
    if @point
      get(@point.latitude, @point.longitude)
    else
      coords = @points.map{|pt| { latitude: pt.latitude, longitude: pt.longitude }}
      get_bulk(coords)
    end
  end

  private

  def get(latitude, longitude)
    response = connection.get("#{latitude}/#{longitude}")
    if response.status == 200
      response.body.to_i
    end
  end

  def get_bulk(coords)
    response = connection.post('bulk', coords.to_json)
    if response.status == 200
      JSON.parse(response.body)
    end
  end

  def connection
    options = {
      headers: { 'Accept' => 'application/json' }
    }
    Faraday.new(endpoint, options) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end

  def endpoint
    'https://codingcontest.runtastic.com/api/elevations'
  end
end