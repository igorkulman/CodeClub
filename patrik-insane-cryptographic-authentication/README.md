# Let's Implement Patrik's Insane Cryptographic Authentication (PICA)!

## Description

Patrik has been experimenting once again - this time, the result is an authentication system better than OAuth! It is overcomplicated and does not really use any cryptography, but hey, at least it's in house and without any dependencies :pepe-smile:

It works in the following way:

- You send an authentication request to the specified endpoint with your username and password (your puzzle input) a. The endpoint is https://code-club-website.patrik-dvoracek.workers.dev/rest/puzzle/2025/september/auth
- The server responds with a greetings token
- You calculate the corresponding greeting from your greetings token and send it back to the server
- Server responds with your authentication token (your puzzle result)

It's that simple!

### Communication Structure

Please note that each of your requests must include the X-Cookie-User header with your username that you use to log in into this system!
Authentication request

Your request:

```json
{
  "type": "credentials",
  "username": "tonik",
  "password": "tonikKonik"
}
```

Server response:

```json
{
  "type": "greeting",
  "token": "superSecretTonikToken"
}
```

Greeting request


Your request:

``` json
{
  "type": "greeting",
  "token": 12345,
}
```

Server response:

```json
{
  "type": "authenticated",
  "result": "superDuperAuthenticatedToken"
}
```

Errors

Each request can fail with an error. Each error is returned as a 400 response with the following JSON structure:

```json
{
  "message": "Invalid credentials",
  "error": {
    "message": "Invalid credentials were received",
    "details": "..."
  }
}
```
### Greeting Token Calculation

Token calculation is simple:

-　Each token consists only of English letters and dashes
-　Remove any dashes from the token
-　Start with the value of 100
- Go through each letter in the token and: a.
-　Take the position of the letter in the English alphabet (abcdefghijklmnopqrstuvwxyz).
-　Your algorithm should be case-insensitive. Positions start at 1. b.
-　Add the position to your current sum. c.
-　Multiply the sum by the ASCII value of the lower-case letter. d.
-　Modulo the result with 4096 to keep the numbers manageable.
- Your greeting token value is the final sum
