#!/bin/bash
set -e

if [ -f ${NORAC_HOME}/wildfly-config.sh ]; then
   echo
   echo Customizing widlfly ...
   echo
   
   /bin/sh ${NORAC_HOME}/wildfly-config.sh
   mv ${NORAC_HOME}/wildfly-config.sh ${NORAC_HOME}/wildfly-config.sh.fin
   
fi

if [ ! -f ${JBOSS_HOME}/modules/com/ii/configuration/main/runtime.properties ]; then
   echo
   echo adding runtime.properties ...
   echo
   
   cp ${NORAC_HOME}/config/runtime.properties ${JBOSS_HOME}/modules/com/ii/configuration/main/runtime.properties
   
fi

echo Starting wildfly
if [ "$1" = 'standalone.sh' ]; then
   ${JBOSS_HOME}/bin/standalone.sh  -c standalone-full.xml -b 0.0.0.0 -bmanagement 0.0.0.0 --debug 8787
fi

exec "$@"