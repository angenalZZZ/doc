#!/bin/sh

sh -c '/a/database/kafka/bin/zookeeper-server-start.sh /a/database/kafka/config/zookeeper.properties &'
sh -c '/a/database/kafka/bin/kafka-server-start.sh /a/database/kafka/config/server.properties &'
sh -c '/a/database/kafka/bin/kafka-server-start.sh /a/database/kafka/config/server-1.properties &'
sh -c '/a/database/kafka/bin/kafka-server-start.sh /a/database/kafka/config/server-2.properties &'
