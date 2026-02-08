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
  cd ./server && ./bin/timer.bin --db=./bin/db --port=8005
};
function s-compile { ## Компиляция серверного приложения
  cd ./server && dart compile exe bin/timer_server.dart -o bin/timer.bin
}
function s-deploy { ## Деплой серверного приложения
  ssh root@djusti.ru "supervisorctl stop timer"
  scp ./server/bin/timer.bin root@djusti.ru:/var/www/timer/timer.bin
  ssh root@djusti.ru "supervisorctl start timer"
}



function build { ## Сборка приложения [-i] [-d]
  cd ./client
  if [ "${2}" == "deb" ] || [ "${2}" == "-i" ] || [ "${2}" == "-d" ] || [ -z "$2" ]; then
    VERSION=`cat pubspec.yaml | grep -Po "^version: \K(.+)$"`
    echo "#define VERSION \"$VERSION\"" > linux/runner/version.h
    sed -ir "s/  Version: .*$/  Version: $VERSION/g" debian/debian.yaml
    flutter build linux
    rm build/linux/x64/release/debian/*.deb
    flutter_build_debian
    if [ "${2}" == "-d" ] || [ "${3}" == "-d" ] || [ "${4}" == "-d" ]; then
        deploy "deb"
    fi
  fi

  if [ "${2}" == "apk" ] || [ "${2}" == "-i" ] || [ "${2}" == "-d" ] || [ -z "$2" ]; then
    rm build/app/outputs/flutter-apk/*.apk
    dart run flutter_launcher_icons
    flutter build apk
    VERSION=`cat pubspec.yaml | grep -Po "^version: \K(.+)$"`
    mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/work-timer_$VERSION.apk
    echo "Build: build/app/outputs/flutter-apk/work-timer_$VERSION.apk"
    if [ "${2}" == "-d" ] || [ "${3}" == "-d" ] || [ "${4}" == "-d" ]; then
      deploy "apk"
    fi
  fi

  if [ "${2}" == "-i" ] || [ "${3}" == "-i" ] || [ "${4}" == "-i" ]; then
    install
  fi
}

function deploy { ## Выгружает на сервер дистрибутивы
  cd ./client
  if [ "${2}" == "deb" ] || [ -z "$2" ]; then
    DEB=`ls build/linux/x64/release/debian | grep .deb`
    scp ./build/linux/x64/release/debian/$DEB root@djusti.ru:/var/www/djusti.ru/htdocs/timer/release/$DEB
  fi
  if [ "${2}" == "apk" ] || [ -z "$2" ]; then
    DEB=`ls build/app/outputs/flutter-apk | grep '.apk$'`
    scp ./build/app/outputs/flutter-apk/$DEB root@djusti.ru:/var/www/djusti.ru/htdocs/timer/release/$DEB
  fi
}

function install { ## Устанавливает приложение локально
  cd ./client
  DEB=`ls build/linux/x64/release/debian | grep .deb`
  sudo apt purge work-timer
  sudo dpkg -i ./build/linux/x64/release/debian/$DEB
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