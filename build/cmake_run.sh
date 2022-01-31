#!/bin/bash
source ./public_config.sh
./cmake_build.sh

pushd ${cmake_source_dir}/${executable_output_path} >> /dev/null

./${target_name}.exe ${1} ${2}
