# login_error_example_app

A small app that uses a custom server to send register and login requests.
These requests can fail, so this needs to be handled accordingly.

The server is the [Login Error Example Server](https://github.com/App-Akademie/login_error_example_server).

## Possible improvements

- Handle case of wrong url or server down in app.
- Use an `Enum` or something similar for error cases instead of Strings.
