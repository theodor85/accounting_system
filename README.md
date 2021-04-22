## Запуск

    docker-compose up --build

## Как накатить в базу хранимые процедуры

При запущенной системе выполнить:

    ./update_database.sh

## Запуск тестов

При запущенной системе выполнить:

    docker-compose exec rails rspec ./spec/references/refs_spec.rb
