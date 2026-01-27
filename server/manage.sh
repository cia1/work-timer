#!/bin/bash

# -----------------------------------------------------------------------------
# В этом блоке определены функции управления проектом. Имя функции соответствует команде manage: ./manage {function-name}
# Указанный комментарий (после ##) используется для генерации справки (./manage.sh help)
# -----------------------------------------------------------------------------

function compile { ## Компиляция серверного приложения
	dart compile exe bin/timer_server.dart -o bin/timer.bin
}

function server { ## Запуск серверного приложения
	./bin/timer.bin --db=./jobs.json --port=8005
};

function deploy { ## Деплой серверного приложения
	ssh root@djusti.ru "supervisorctl stop timer"
	scp ./bin/timer.bin root@djusti.ru:/var/www/timer/timer.bin
	ssh root@djusti.ru "supervisorctl start timer"
}

# -----------------------------------------------------------------------------




# Служебные команды
function help { ## Справка по командам
	sed -E -n '/^function [a-zA-Z0-9_+-]+ \{ ## /p' "${0}" | sed "s/function /  $(tput bold)/" | sed "s/ { ## /$(tput sgr0)~/" | column -t -s"~"
};

for arg do
  shift
  [ "$arg" = "-no-host" ] && USEHOST=0 && continue
  set -- "$@" "$arg"
done

if [[ -z $1 ]]; then
	help;
else
	${1} $@;
fi