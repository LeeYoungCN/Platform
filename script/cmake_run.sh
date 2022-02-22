#!/bin/bash
source ./public_config.sh
./cmake_build.sh "all"

pushd ${cmake_source_dir}/${executable_output_path} >> /dev/null

./${target_name}* ${*}
