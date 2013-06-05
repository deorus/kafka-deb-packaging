kafka-deb-packaging
===================

Simple debian packaging for Apache Kafka

This assumes you have fpm Ruby gem installed on your environment.
Please put your desired configurations on kafka-broker.default before running, or override them in the machine using Chef or other configuration management tool.


For 0.8, invoke

./build_kafka_from_releasedir <src_dir>

Adapt in the script the version. The default is 0.8.0-SNAPSHOT.


