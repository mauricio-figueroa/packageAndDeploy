#!/bin/bash

ZIP_NAME=


function parseValidArguments() {
  while :; do
    case $1 in

      -zn|--zipname) ZIP_NAME="$2"; shift
      ;;
      -h|--help) help
      ;;
      *) break
    esac
    shift
  done
}


function validateArguments(){

  if [[ -z "$ZIP_NAME" ]]; then
    echo "Zip name required ( Param: -zn or--zipname)"
    exit 1;
  fi
}


function help() {
  echo "#################"

  echo "Options you can use:"
  echo "  -h   | --help : this help"
  echo "  -zp  | --zipname :  name of zip file (required)"

  echo "#################"
  exit 1
}

  function log() {
    echo "$(date +%Y-%m-%d'T'%H:%M:%S)" $@
  }


##############
## Main
##############

parseValidArguments $@
validateArguments

log "INFO" "INFO PARAMS"
log "INFO" "=================="
log "INFO" "Zip name: $ZIP_NAME"
log "INFO" "=================="

mvn package
rc=$?
if [[ $rc -ne 0 ]] ; then
  echo 'BUILD FAILURE';
  exit $rc
fi
mv target/api*.jar target/api.jar
zip -r -j  "$ZIP_NAME.zip" target/newrelic/newrelic.jar target/api.jar Procfile src/main/resources/newrelic.yml

##############
## End Main
##############
