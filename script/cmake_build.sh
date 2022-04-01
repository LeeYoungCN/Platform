#!/bin/bash
source ./public_config.sh
pushd ${cmake_source_dir} >> /dev/null
target=all

if [ $# -ge 1 ]; then
    target=${1}
fi
cmake --build ./${buildcache_path} --target ${target}

