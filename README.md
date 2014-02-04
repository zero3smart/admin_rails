Backend
=======
API
---

# Error codes

```
{
    0 100    UNDEFINED_ERROR          Undefined error
    0 101    VALIDATION_ERROR 
    0 102    TOKEN_EXPIRED          Authentication token expired
    0 103    INVALID_TOKEN          Invalid authentication token
    0 104    NOT_AUTHENTICATED
    0 105    ASSISTANT_BUSY
    0 106    WRONG_PARAMETERES      Wrong user parametres
    0 107    AUTH_SMS_NOT_SENT      Authentication SMS not sent
    0 108    CONNECTION_EXISTS      Connection already exists
    0 109    NOT_MATCH
    0 110    NO_VALIDATION_CODE
    0 111    USER_NOT_EXISTS
    0 112    USER_ID_BLANK          User ID can't be blank
    
}
```

# Authentication

### Validate
API Call
```
curl -i -XPOST http://rea-rails-development.herokuapp.com/api/authentication/validate -d 'user_id=6&token=-x1wSyy68Fstzx1ZCZ_h'
```
Response

Ok, sends 200
```
{"name":"Jiri Kratochvil","role":"admin"}
```
Errors:
```
{"error_info":{"code": 102, title: 'Token expired', message: 'Authentication token expired'}}
```
```
{"error_info":{"code": 103, title: '', message: 'Validation code not match'}}
```

### Device user registration

Resister user or send new code to activate new device

```
curl http://rea-rails-development.herokuapp.com/api/authentication/register -d 'phone=420xxxxxxxxx'
```

Ok, send 200
```
{}
```
Errors:
```
{ error_info: { code: 101, message: "Wrong format or blank phone number" } }
```

```
{ error_info: { code: 106, message: "Authentication sms not sent" } }
```

```
{ error_info: { code: 100, title: 'UNDEFINED ERROR', message: '' } }
```

### Device code validation
Validate recieved validation code

```
curl http://rea-rails-development.herokuapp.com/api/authentication/validate_code -d 'phone=420xxxxxxxxx&validation_code=1234'
```

Ok, send 200
```
{"user":{"id":12,"name":null,"email":null,"phone":"+420xxxxxxxxx","auth_token":"kL2LLCmyKsbszkWzQeU7","role":"user","last_token":null,"token_updated_at":"2014-01-06T10:43:13.618Z","validation_code":null}}
```
Errors:
```
{ error_info: { code: 109, title: '', message: 'Validation code not match' } }
```

```
{ error_info: { code: 110, title: '', message: 'No validation code' } }
```

```
{ error_info: { code: 111, title: '', message: 'User not exists'} }
```

# Calls
### Get call info !!ONLY WHEN NOTIFICATION IS SENT!!
API Call
```
curl http://rea-rails-development.herokuapp.com/api/calls\?call_id=Ul2jrfWYQG8QsQ2RoTqbzA
```
Response

Ok, send 200
```
{"assistant_token":"dsfsdf","assistant_id":"4","caller_id":"1","session_id":"adafa","format":"json","action":"create","controller":"api/v1/notifications","notification":{"assistant_token":"T1==cGFydG5l","assistant_id":"4","caller_id":"1","session_id":"1_MX4zODgy"}}
```

Errors:
```
{"error_info":{"code":101,"message":"Invalid call id"}}
```

# Contacts

### Get all contacts

API Call
```
curl http://rea-rails-development.herokuapp.com/api/users/1/contacts.json?auth_token=XXX
```
Response

Ok, sends 200
```
{"contacts":[{"id":33,"name":null,"email":null,"phone":"+420602302314","is_pending":true,"is_rejected":false,"is_removed":false, "nickname":"Jirka"}]}
```

Errors:
```
{"error":"You need to sign in or sign up before continuing."}
```

### Inivte new contact
API Call
```
curl -H 'Content-Type: application/json' -X POST http://rea-rails-development.herokuapp.com/api/users/:user_id/contacts/invite?auth_token=xxxXXXX -d '{"contact":{"nickname":"Papuska", "phone":"421917328431"}}'
```
Response

Ok, send 200
```
{{"invited_user":{"id":34,"name":null,"phone":"+420602302314","nickname":"Papuska Moja"}}}
```
Errors:
```
{"error_info":{"code":108, title: '', message: 'Connection already exists'}}
```

```
{ error_info: { code: 101, message: "User_id blablabla cant be blank, Contact_id cant be blank..." } }
```

### Accept/Decline/Remove a contact
API Call

Accept
```
curl -XPOST http://rea-rails-development.herokuapp.com/api/users/1/contacts/accept?auth_token=XXX   -d 'contact_id=2'
```
Decline
```
curl -XPOST http://rea-rails-development.herokuapp.com/api/users/1/contacts/decline?auth_token=XXX  -d 'contact_id=2'
```
Remove
```
curl -XDELETE http://rea-rails-development.herokuapp.com/api/users/1/contacts/remove?auth_token=XXX -d 'contact_id=2'
```
Dismiss
```
curl -XDELETE http://rea-rails-development.herokuapp.com/api/users/1/contacts/remove?auth_token=XXX -d 'contact_id=2'
```
Response 

Ok, send 200 
```
{}
```

# Device 
### Device create
API Calls
```
curl -H 'Content-Type: application/json' -X POST http://rea-rails-development.herokuapp.com/api/devices -d '{"auth_token":"xxxxxxx","device":{"user_id":"23", "token":"fdsfdsfdsfdsf"}}'
```
Response

If device is already registered to my account send 200
```
{}
```

If device not registered to my account, it is created a send device object
```
{"id":4,"token":"myReallySecretTokenUniq","user_id":4,"created_at":"2014-01-17T13:09:32.503Z","updated_at":"2014-01-17T13:09:32.503Z"}
```

If device errors 
```
{"error_info":{"code": 101,"message": "token has already been taken"}}
```
# Notifications

### Get all notifications for user
API call
```
curl http://rea-rails-development.herokuapp.com/api/notifications?user_id=4&auth_token=xxxXXX
```

Responds

Ok, send 200
```
{"notifications":[{"type":"invitation","user":{"id":1,"name":"Tomas Stanik"}},{"type":"invitation","user":{"id":2,"name":"Jana Filova"}},{"type":"rejection","user":{"id":3,"name":"Jakub Arnold"}},{"type":"rejection","user":{"id":13,"name":"Petr Novák"}},{"type":"removal","user":{"id":11,"name":"E"}},{"type":"removal","user":{"id":12,"name":"F"}}]}
```

Errors:
```
{ "error_info": { "code": 111, title: '', message: 'User not exists'} }
```
# Feedbacks

User can send feedbacks

Required fields:

* feedback_type - feedback type string [feature, bug, other]
* message - text of feedback
* user_id - user id of logged user


```
curl -H 'Content-Type: application/json' -H "Accept: application/json" -X POST -d '{"feedback":{"message":"I have bug when starting call. No cancel button appears! Thanks.", "feedback_type":"bug", "user_id":"4"}}' http://rea-rails-development.herokuapp.com/api/feedbacks
```
Response

Ok, send 200
```
{}
```

Error:
```
{"error_info":{"code":101,"message": "feedback_type can't be blank , message can't be blank"}}
```
# Users update

User can update his name and e-mail

Required fields:
* email - user e-mail

```
curl -H 'Content-Type: application/json' -X PUT http://rea-rails-development.herokuapp.com/api/users/:id -d '{"user":{"name":"Karel Novák", "phone":"+421917328431", "email":"name@example.com", "auth_token":"VMdGAUSzUmppuoxr4CSg"}}'
```
Ok, send 200
```
{}
```

Error:
E-mail is invalid
```
{"error_info":{"code": 101, "message":"email is invalid"]}}
```
User try to change another user or invalid or expired token
```
{"error_info":{"code":103, title: '',  message: "Invalid authentication token" }}
```





    