Backend
=======

API
---

# Contacts

Get all contacts or a user

```
curl http://remoteassistant-backend-test.herokuapp.com/api/users/1/contacts.json
```

Create a new contact for (for user with id 1, target_id is the other user who's being added as a contact)

```
curl -i -XPOST http://remoteassistant-backend-test.herokuapp.com/api/users/1/contacts.json\?auth_token=FR3wtp_6gN33kGM8TAs1 -d "contact[target_id]=2"
```

### Sessions ###

GET ALL SESSIONS
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://remoteassistant.herokuapp.com/api/sessions
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://localhost:3000/api/sessions

GET MY SESSION (sender)
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"session":{"sender_id":2}}' http://remoteassistant.herokuapp.com/api/sessions
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"session":{"sender_id":12}}' http://localhost:3000/api/sessions

GET MY SESSION (recipient)
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"session":{"recipient_id":2}}' http://remoteassistant.herokuapp.com/api/sessions
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"session":{"recipient_id":12}}' http://localhost:3000/api/sessions

CREATE SESSION
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"session":{"sender_id":1, "recipient_id":2}}' http://remoteassistant.herokuapp.com/api/sessions
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"session":{"sender_id":11, "recipient_id":12}}' http://localhost:3000/api/sessions

DELETE SESSION
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X DELETE http://remoteassistant.herokuapp.com/api/sessions/2
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X DELETE http://localhost:3000/api/sessions/2

### Locations ###

GET ALL LOCATIONS
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://remoteassistant.herokuapp.com/api/locations
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET http://localhost:3000/api/locations

GET SESSION LOCATION
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"location":{"session_id":4}}' http://remoteassistant.herokuapp.com/api/locations
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X GET -d '{"location":{"session_id":56}}' http://localhost:3000/api/locations

CREATE / UPDATE LOCATION
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"location":{"session_id":4, "lat":0.1, "lon":0.2, "bearing":3}}' http://remoteassistant.herokuapp.com/api/locations
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"location":{"session_id":56, "lat":0.1, "lon":0.2, "bearing":3}}' http://localhost:3000/api/locations
