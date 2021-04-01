## Запуск

    docker-compose up --build

## Как накатить в базу хранимые процедуры

Обязательно накатывать в две базы! В основную `acc_sys` и в тестовую `acc_sys_test`!

При запущенной системе выполнить:

    docker-compose exec postgres psql -U debug -h localhost -d acc_sys -f /stored_procedures/references.sql

## Запуск тестов

При запущенной системе выполнить:

    docker-compose exec rails rspec ./spec/references/refs_spec.rb
