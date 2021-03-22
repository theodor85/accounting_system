## Запуск

    docker-compose up --build

## Запуск тестов

При запущенной системе выполнить:

    docker-compose exec rails rspec ./spec/references/refs_spec.rb

При этом появляется ошибка вида:

```
  1) Reference can create table
     Failure/Error:
       raise WrongScopeError,
             "`#{name}` is not available from within an example (e.g. an " \
             "`it` block) or from constructs that run in the scope of an " \
             "example (e.g. `before`, `let`, etc). It is only available " \
             "on an example group (e.g. a `describe` or `context` block)."
     
       `name` is not available from within an example (e.g. an `it` block) or from constructs that run in the scope of an example (e.g. `before`, `let`, etc). It is only available on an example group (e.g. a `describe` or `context` block).
```
