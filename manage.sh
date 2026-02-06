#!/bin/bash

# -----------------------------------------------------------------------------
# В этом блоке определены функции управления проектом. Имя функции соответствует команде manage: ./manage {function-name}
# Указанный комментарий (после ##) используется для генерации справки (./manage.sh help)
# -----------------------------------------------------------------------------
function s-test { ## Выполныет тесты серверного приложения
    if [[ -n "$2" ]]; then
      PARAM="test/$2_test.dart"
    else
      PARAM=''
    fi
    cd server && dart test $PARAM
}
function s-server { ## Запуск серверного приложения
  cd ./server && ./bin/timer.bin --db=./db --port=8005
};
function s-compile { ## Компиляция серверного приложения
  cd ./server && dart compile exe bin/timer_server.dart -o bin/timer.bin
}
function s-deploy { ## Деплой серверного приложения
  ssh root@djusti.ru "supervisorctl stop timer"
  scp ./server/bin/timer.bin root@djusti.ru:/var/www/timer/timer.bin
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