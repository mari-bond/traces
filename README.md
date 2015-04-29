# traces

Entities:

  Point - point of a trace. Includes gps coordinates (longitude, latitude), distance and elevation. 
  Trace - has array of points

Functionality:

  API allows to do traces CRUD actions. Calculates distance and elevation for points.
  
Requests examples:

  curl -i -X POST -d @trace3.json http://localhost:3000/traces --header "Content-Type: application/json"
  
  curl -i -X GET http://localhost:3000/traces/3 --header "Content-Type: application/json"
  
  curl -i -X PUT -d @trace3.json http://localhost:3000/traces/3 --header "Content-Type: application/json"
  
  curl -i -X DELETE http://localhost:3000/traces/3 --header "Content-Type: application/json"

Performance improvement:

  For better performance points are saved as json. As we don't need to do manipulations with points (update, delete)  we can save them as json and put directly to Trace. It allows to fetch Trace points much faster. Also it's better to save points to text field insted of json, because ActiveRecord would deserialize all points each time we read Trace entity.

Tasks:

  rake points:save_as_json             # Saves points as json and put to Trace

Testing:

  bundle exec rspec
