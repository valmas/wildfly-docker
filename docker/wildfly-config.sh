#!/bin/sh
set -e
${JBOSS_HOME}/bin/jboss-cli.sh --file=${NORAC_HOME}/wildfly/wildfly-config.cli \
  -Ddb.connection.url=$DB_CONNECTION_URL \
  -Ddb.user=$DB_USER \
  -Ddb.pass=$DB_PASS