#!/bin/sh

sh -c '/4g/database/kafka/bin/zookeeper-server-start.sh /4g/database/kafka/config/zookeeper.properties &'
sh -c '/4g/database/kafka/bin/kafka-server-start.sh /4g/database/kafka/config/server.properties &'
sh -c '/4g/database/kafka/bin/kafka-server-start.sh /4g/database/kafka/config/server-1.properties &'
sh -c '/4g/database/kafka/bin/kafka-server-start.sh /4g/database/kafka/config/server-2.properties &'
