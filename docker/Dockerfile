## Wildfly image ##
#  Wildfly bundled with PostgreSQL drivers
#
# docker build --rm --build-arg http_proxy=http://pascal:80/ --build-arg https_proxy=http://pascal:80/ --tag="acts/base-wildfly:9.0.2" ./
# docker run -d -p 8080:8080 -p 9990:9990 --name wildfly acts/base-wildfly:9.0.2
###
FROM jboss/wildfly:10.0.0.Final
ARG WAR_NAME=noracWeb.war

# Set the JBOSS_HOME env variable
ENV NORAC_HOME  /home/norac
ADD config/ $NORAC_HOME/wildfly

# Install Oracle driver
RUN \
    mkdir -p ${JBOSS_HOME}/modules/com/oracle/main && \
    cp ${NORAC_HOME}/wildfly/ojdbc6.jar ${JBOSS_HOME}/modules/com/oracle/main/ojdbc6.jar && \
    cp ${NORAC_HOME}/wildfly/jboss-ojdbc-module.xml ${JBOSS_HOME}/modules/com/oracle/main/module.xml

RUN \
    mkdir -p ${JBOSS_HOME}/modules/com/ii/configuration/main && \
    cp ${NORAC_HOME}/wildfly/configuration-module.xml ${JBOSS_HOME}/modules/com/ii/configuration/main/module.xml

# Enable resolve-parameter-values in order for jboss-cli to resolve parameters
RUN sed -i "s|<resolve-parameter-values>false</resolve-parameter-values>|<resolve-parameter-values>true</resolve-parameter-values>|" ${JBOSS_HOME}/bin/jboss-cli.xml 

WORKDIR ${JBOSS_HOME}

# Add a default admin user.
RUN ${JBOSS_HOME}/bin/add-user.sh --silent admin admin

#Workaround: WFLYCTL0056: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current to...
RUN rm -rf ${JBOSS_HOME}/standalone/configuration/standalone_xml_history

# Configure Wildfly
RUN ${JBOSS_HOME}/bin/jboss-cli.sh --file=${NORAC_HOME}/wildfly/base.cli

#Workaround: WFLYCTL0056: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current to...
RUN rm -rf ${JBOSS_HOME}/standalone/configuration/standalone_xml_history

# ADD ${NORAC_HOME}/wildfly/noracWeb.war ${JBOSS_HOME}/standalone/deployments

RUN \
    cp ${NORAC_HOME}/wildfly/${WAR_NAME} ${JBOSS_HOME}/standalone/deployments

# Set the default command to run on boot
# Boot standalone WildFly and bind to all interface
COPY docker-entrypoint.sh ${NORAC_HOME}/
COPY wildfly-config.sh ${NORAC_HOME}/
USER root
RUN chmod +x ${NORAC_HOME}/docker-entrypoint.sh
RUN chmod +x ${NORAC_HOME}/wildfly-config.sh
RUN chown jboss:jboss ${NORAC_HOME}
RUN chown jboss:jboss ${NORAC_HOME}/docker-entrypoint.sh
RUN chown jboss:jboss ${NORAC_HOME}/wildfly-config.sh
USER jboss

WORKDIR $JBOSS_HOME/bin
ENTRYPOINT ["/home/norac/docker-entrypoint.sh"]
CMD ["standalone.sh",   "-c", "standalone-full.xml", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "--debug", "8787" ]