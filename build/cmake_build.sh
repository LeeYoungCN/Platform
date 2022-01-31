#!/bin/bash
source ./public_config.sh
pushd ${cmake_source_dir} >> /dev/null

cmake --build ./${buildcache_path} --target ${target}
