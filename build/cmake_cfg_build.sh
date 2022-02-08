#!/bin/bash
source ./public_config.sh
source ./public_shell_func.sh

cmake_cmd="cmake -S ${cmake_source_dir} -B ${cmake_source_dir}/${buildcache_path}"

function cmake_config()
{
    if [ "${os}" == "Windows" ]; then
        ${cmake_cmd} -G "MinGW Makefiles" ${1}
    else
        ${cmake_cmd} ${1}
    fi
}

create_new_folder_and_del_old ${cmake_source_dir}/${buildcache_path}

if [ ${#target_name} -gt 0 ]; then
    cmake_config
elif [ $# -gt 0 ]; then
    for target in $*; do
        set_exe_path_in_launch ${target}
        cmake_config "-DTARGET_NAME=${target}"
    done
else
    echo "no target_name!"
    exit
fi

./cmake_build.sh
