#!/bin/bash

LAST_UPLOADED_LINE=$( aws s3 ls s3://elasticbeanstalk-sa-east-1-980074370134/com/cash/app/ | tail -1)
LIST_UPLOADED=
LAST_UPLOADED_FILE_NAME=
ENVIRONMENT=
VERSION=


function parseValidArguments() {
  while :; do
    case $1 in

      -env|--environment) ENVIRONMENT="$2"; shift
      ;;
      -v|--version) VERSION="$2"; shift
      ;;
      -h|--help) help
      ;;
      -ls|--list) list
      ;;
      *) break
    esac
    shift
  done
}

function validateArguments(){

  if [[ -z "$ENVIRONMENT" ]]; then
    echo "Environment name required ( Param: -env or--environment)"
    exit 1;
  fi
}


function help() {
  echo "#################"

  echo "Options you can use:"
  echo "  -h   | --help : this help"
  echo "  -env  | --environment :  name of environment (required)"
  echo "  -v  | --version :  name of version to deploy (option)| if the parameter is empty, deploy the last version uploaded to s3"
  echo "  -l  | --list :  list application versions stored in s3"

  echo "#################"
  exit 1
}

function list() {
  LIST_UPLOADED=$( aws s3 ls s3://elasticbeanstalk-sa-east-1-980074370134/com/cash/app/  | tail -10)

  log "INFO" "=================="
  log "INFO" "Last 10 versions stored in s3:"
  log "INFO" "=================="

  echo "$LIST_UPLOADED"
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
log "INFO" "Environment: $ENVIRONMENT"
log "INFO" "Version: $VERSION"
log "INFO" "=================="


if [[ -z "$VERSION" ]];
then
    log "INFO" "=================="
    log "INFO" "Version parameter is empty, it proceeds to deploy the latest version available in s3"
    log "INFO" "=================="
    LAST_UPLOADED_FILE_NAME=$(cut -d ' ' -f6 <<<"$LAST_UPLOADED_LINE")
    log "INFO" "Last Version:  $LAST_UPLOADED_FILE_NAME"
    log "INFO" "=================="
    aws elasticbeanstalk update-environment --environment-name $ENVIRONMENT --version-label $LAST_UPLOADED_FILE_NAME --region sa-east-1
    log "INFO" "The deploy is in process!"
    log "INFO" "=================="
    log "INFO" "=================="
    log "INFO" "=================="

    log "INFO" "Good bye!"
else
    log "INFO" "Proceeds to deploy version  $VERSION"
    log "INFO" "=================="
    aws elasticbeanstalk update-environment --environment-name $ENVIRONMENT --version-label $VERSION --region sa-east-1
    log "INFO" "The deploy is in process!"
    log "INFO" "=================="
    log "INFO" "=================="
    log "INFO" "=================="


  fi


##############
## Main
##############

