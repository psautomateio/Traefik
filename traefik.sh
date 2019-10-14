#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
source /psa/traefik/functions.sh

traefikstart() {

traefikpaths #functions
traefikstatus #functions
layoutbuilder # functions - builds out menu

case $typed in
    1 )
      bash /psa/traefik/tld.sh
      bash /psa/traefik/traefik.sh
      exit ;;
    2 )
      providerinterface
      bash /psa/traefik/traefik.sh
      exit ;;
    3 )
      domaininterface
      bash /psa/traefik/traefik.sh
      exit ;;
    4 )
      emailinterface
      bash /psa/traefik/traefik.sh
      exit ;;
    5 )
      delaycheckinterface
      bash /psa/traefik/traefik.sh
      exit ;;
    a )
      blockdeploycheck
      deploytraefik
      bash /psa/traefik/traefik.sh
      exit ;;
    A )
      blockdeploycheck
      deploytraefik
      bash /psa/traefik/traefik.sh
      exit ;;
    B )
      destroytraefik
      bash /psa/traefik/traefik.sh
      exit ;;
    b )
      destroytraefik
      bash /psa/traefik/traefik.sh
      exit ;;
    z )
      exit ;;
    Z )
      exit ;;
    * )
      traefikstart ;;
esac

}

main /psa/var/traefik.provider NOT-SET provider
main /psa/var/server.email NOT-SET email
main /psa/var/server.delaycheck 60 delaycheck
main /psa/var/server.domain NOT-SET domain
main /psa/var/tld.program NOT-SET tld
main /psa/var/traefik.deploy 'Not Deployed' deploy

traefikstart
