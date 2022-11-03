Todo
===

> Todo App written in Elixir/Phoenix using Postgres

Task description: https://kb.sruplex.com/public/posts/elixir-take-home-exercise-jdgbsjkp

Demo: https://floral-frog-2944.fly.dev

## Setup

Following dependencies are required:

 - Erlang 25.1.2
 - Elixir 1.14.1-otp-25
 - Postgres 14

.tools-versions file is in the project root dir for the ASDF users

Compile Application and Assets:

```bash
$ mix do deps.get, compile
$ mix do ecto.reset
```

<br>




## Running the App

To start the app

```bash
$ mix phx.server
```



## Implementation Details

Todo lists consists of Todo items;

All creations and updates (for both lists and items) are broadcasted to all
connected clients

A list title can not be changed if it was archived and there's row lock
performed on the update to ensure list was not archived while being updated

An item can not be created or updated in an archived list - to enforce this and
avoid possible race conditions, a "FOR UPDATE" lock is used

By default, every 5 minutes a cleanup will be performed: all lists that were not
updated for longer than 1 day, will be marked as archived. The period and list
ttl are configurable via `todo.lists_cleanup` config key.

<br>




## Testing and Contributing

```bash
$ mix test
```

<br>




## License

The code will soon be available under the terms of the [MIT License][license].