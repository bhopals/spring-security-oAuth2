#!/bin/sh
getPort() {
    echo $1 | cut -d : -f 3 | xargs basename
}

echo "********************************************************"
echo "Waiting for the eureka server to start on port $(getPort $EUREKASERVER_PORT)"
echo "********************************************************"
while ! `nc -z eurekaserver  $(getPort $EUREKASERVER_PORT)`; do sleep 3; done
echo "******* Eureka Server has started"


echo "********************************************************"
echo "Waiting for the database server to start on port $(getPort $DATABASE_PORT)"
echo "********************************************************"
while ! `nc -z database $(getPort $DATABASE_PORT)`; do sleep 3; done
echo "******** Database Server has started "

echo "********************************************************"
echo "Waiting for the configuration server to start on port $(getPort $CONFIGSERVER_PORT)"
echo "********************************************************"
while ! `nc -z configserver $(getPort $CONFIGSERVER_PORT)`; do sleep 3; done
echo "*******  Configuration Server has started"

echo  "********************************************************"
echo "Waiting for the elasticsearch server to start  on port $(getPort $ES_PORT) "
echo "********************************************************"
while ! `nc -z es $(getPort $ES_PORT)`; do sleep 3; done
echo "*******  Elasticseach Server has started"

echo "********************************************************"
echo "Starting Organization Service                           "
echo "********************************************************"
java -Djava.security.egd=file:/dev/./urandom -Dserver.port=$SERVER_PORT   \
     -Deureka.client.serviceUrl.defaultZone=$EUREKASERVER_URI             \
     -Dspring.cloud.config.uri=$CONFIGSERVER_URI                          \
     -Dspring.profiles.active=$PROFILE                                   \
     -Dsecurity.oauth2.resource.userInfoUri=$AUTHSERVER_URI               \
     -jar /usr/local/organizationservice/@project.build.finalName@.jar

