#!/bin/bash
source ./public_config.sh
pushd ${cmake_source_dir} >> /dev/null

function CreateFolder()
{
    if [ -e ${1} ];then
        rm -rf ${1}
    fi
    mkdir ${1}
}

CreateFolder ${cmake_source_dir}/${executable_output_path}
CreateFolder ${cmake_source_dir}/${buildcache_path}

cmake -S ${cmake_source_dir} -B ${cmake_source_dir}/${buildcache_path} -G "MinGW Makefiles"

popd >> /dev/null
./cmake_build.sh