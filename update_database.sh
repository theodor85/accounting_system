#!/usr/bin/sh

docker-compose exec postgres psql -U debug -h localhost -d acc_sys -f /stored_procedures/system.sql
docker-compose exec postgres psql -U debug -h localhost -d acc_sys -f /stored_procedures/references.sql

docker-compose exec postgres psql -U debug -h localhost -d acc_sys_test -f /stored_procedures/system.sql
docker-compose exec postgres psql -U debug -h localhost -d acc_sys_test -f /stored_procedures/references.sql
