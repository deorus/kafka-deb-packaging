#!/bin/bash
set -e
set -u
name=kafka
version=0.8.0-SNAPSHOT
description="Apache Kafka is a distributed publish-subscribe messaging system."
url="https://kafka.apache.org/"
arch="all"
section="misc"
license="Apache Software License 2.0"
package_version="-1"
scala_version=2.9.2
src_dir=${1:-"kafka"}
release_dir=$src_dir/target/RELEASE/kafka_$scala_version-$version
origdir="$(pwd)"
build_dir=$origdir/tmp/kafka/build

#_ MAIN _#
rm -rf ${name}*.deb

rm -rf $build_dir
mkdir -p $build_dir
mkdir -p $build_dir/usr/lib/kafka
mkdir -p $build_dir/etc/default
mkdir -p $build_dir/etc/init
mkdir -p $build_dir/etc/kafka
mkdir -p $build_dir/var/log/kafka


# configurations
pushd $build_dir
cp ${origdir}/kafka-broker.default etc/default/kafka-broker
cp ${origdir}/kafka-broker.upstart.conf etc/init/kafka-broker.conf
popd

# build kafka
pushd $src_dir
./sbt "++$scala_version update"
./sbt "++$scala_version package"
./sbt "++$scala_version release-zip"
popd


# move the stuff from release dir to the build dir (where the package is being prepared)
pushd $release_dir
mv bin $build_dir/usr/lib/kafka/
mv config $build_dir/usr/lib/kafka/
mv libs $build_dir/usr/lib/kafka/
mv *jar $build_dir/usr/lib/kafka/
popd

pushd $build_dir
fpm -t deb \
    -n ${name} \
    -v ${version}${package_version} \
    --description "${description}" \
    --url="{$url}" \
    -a ${arch} \
    --category ${section} \
    --vendor "" \
    --license "${license}" \
    --prefix=/ \
    -s dir \
    -- .
mv kafka*.deb ${origdir}
popd
