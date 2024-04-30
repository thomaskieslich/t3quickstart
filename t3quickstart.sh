#!/bin/bash

set -x
set +e

## Load Environment from .env File
if [ -f ${BASH_SOURCE%/*}/.env ]; then
  source "${BASH_SOURCE%/*}/.env"
fi

## Create Project Directory
createDirectory() {
  mkdir -p ${PROJECT_NAME}
  cd ${PROJECT_NAME} || exit
}

## Setup ddev
setupDDEV() {
  ddev config \
    --project-name=${PROJECT_NAME} \
    --webserver-type=apache-fpm \
    --php-version=${PHP_VERSION} \
    --database=${DATABASE_VERSION} \
    --project-type=typo3 \
    --docroot=public \
    --web-environment="TYPO3_CONTEXT=Development" \
    --disable-settings-management=false

  ddev config --web-environment-add="COMPOSER_ROOT_VERSION=${COMPOSER_ROOT_VERSION}"
}

## install TYPO3
installTYPO3() {
  ddev start
  rm -f .DS_Store
  ddev composer create --yes --no-interaction typo3/cms-base-distribution:"^${TYPO3_BASE_VERSION}"

  ## better Structure v11
  if [ ${TYPO3_BASE_VERSION} = 11.5 ]; then
    echo 'Change cms-composer-installers for TYPO3 11'
    ddev composer config allow-plugins.typo3/cms-composer-installers true
    ddev composer require --no-interaction "typo3/cms-composer-installers:^4.0@rc"
  fi

  ddev composer config --no-interaction --unset platform
  ddev exec "sed -i 's/typo3cms install:fixfolderstructure/typo3 install:fixfolderstructure/g' composer.json"
  ddev composer require --no-interaction "helhum/typo3-console:^${TYPO3_CONSOLE_VERSION}"
}

## Setup TYPO3
setupTYPO3() {
  ddev typo3 install:setup \
    --no-interaction \
    --admin-user-name=${TYPO3_USERNAME} \
    --admin-password=${TYPO3_PASSWORD} \
    --use-existing-database \
    --web-server-config=apache \
    --site-name="TYPO3 ${TYPO3_BASE_VERSION}"
}

## Installs necessary packages if INSTALL_INTRODUCTION_PACKAGE is set to 1
installIntroductionPackage() {
  ## Install Introduction Package
  if [ ${INSTALL_INTRODUCTION_PACKAGE} = 1 ]; then
    ddev composer require "typo3/cms-introduction:^${INTRODUCTION_VERSION}"
    ddev typo3 install:extensionsetupifpossible
    ddev composer remove typo3/cms-introduction

    ## Reinstall Extensions
    ddev composer require "bk2k/bootstrap-package:^${BOOTSTRAP_PACKAGE_VERSION}"
    ddev composer require "b13/container:^${CONTAINER_VERSION}"
    ddev composer require "typo3/cms-indexed-search:^${TYPO3_BASE_VERSION}"
  fi
}

## Complete TYPO3 sysexts
getAdditionalModules() {
  ddev composer require "typo3/cms-filemetadata:^${TYPO3_BASE_VERSION}"
  ddev composer require "typo3/cms-linkvalidator:^${TYPO3_BASE_VERSION}"
  ddev composer require "typo3/cms-lowlevel:^${TYPO3_BASE_VERSION}"
  ddev composer require "typo3/cms-opendocs:^${TYPO3_BASE_VERSION}"
  ddev composer require "typo3/cms-recycler:^${TYPO3_BASE_VERSION}"
  ddev composer require "typo3/cms-redirects:^${TYPO3_BASE_VERSION}"
  ddev composer require "typo3/cms-reports:^${TYPO3_BASE_VERSION}"
  ddev composer require "typo3/cms-scheduler:^${TYPO3_BASE_VERSION}"
}

## Clean System
cleanSystem() {
  ddev typo3 install:fixfolderstructure -n
  ddev typo3 database:updateschema -n
  ddev typo3 install:extensionsetupifpossible -n
  ddev typo3 upgrade:run -n
  ddev typo3 cache:flush -n
  ddev typo3 cache:warmup -n
}

## delete Project
deleteProject() {
  cd ${PROJECT_NAME} || exit
  ddev delete --omit-snapshot --yes
  cd ..
  rm -rf ${PROJECT_NAME}
}

case "$1" in
install)
  resetProject
  createDirectory
  setupDDEV
  installTYPO3
  setupTYPO3
  installIntroductionPackage
  getAdditionalModules
  cleanSystem
  ;;
delete)
  deleteProject
  ;;
*)
  echo 'install | delete'
  ;;
esac
