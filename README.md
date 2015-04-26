# traces

Requests examples:

curl -i -X POST -d @trace3.json http://localhost:3000/traces --header "Content-Type: application/json"

curl -i -X GET http://localhost:3000/traces/3 --header "Content-Type: application/json"

curl -i -X PUT -d @trace3.json http://localhost:3000/traces/3 --header "Content-Type: application/json"

curl -i -X DELETE http://localhost:3000/traces/3 --header "Content-Type: application/json"
