## Запуск

    docker-compose up --build

## Как накатить в базу хранимые процедуры

При запущенной системе выполнить:

    ./update_database.sh

## Запуск тестов

При запущенной системе выполнить:

    docker-compose exec rails rspec ./spec/references/refs_spec.rb

Запуск end-to-end тестов:

    docker-compose exec rails rspec ./spec/features/refs_e2e_spec.rb
