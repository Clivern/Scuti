### To create a new Project

```zsh
$ curl -X POST "http://localhost:4000/api/v1/project" -d '{"name": "scuti", "description": "Scuti Project", "environment": "prod", "username": "admin", "secret": "secret"}' -H 'Content-Type: application/json' -s | jq .

{
  "createdAt": "2023-05-25T20:20:29",
  "description": "Scuti Project",
  "environment": "prod",
  "id": 1,
  "name": "scuti",
  "secret": "admin",
  "updatedAt": "2023-05-25T20:20:29",
  "username": "admin"
}
```
