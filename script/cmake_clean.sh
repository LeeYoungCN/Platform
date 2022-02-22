#!/bin/bash
source ./public_config.sh
pushd ${cmake_source_dir} >> /dev/null

rm -rf ${executable_output_path}
rm -rf ${buildcache_path}
