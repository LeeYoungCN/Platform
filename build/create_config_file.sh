#!/bin/bash
source ./public_shell_func.sh
platform_script_path=$(pwd)

file_name=public_config.sh

# 写入public_config.sh 文件
function write_to_file()
{
    echo ${1} >> ${file_name}
}

# 获取CMakeList，TXT所在路径
function get_cmake_source_dir()
{
    cmake_source_dir=$(cd ../..;pwd)
    write_to_file "cmake_source_dir=${cmake_source_dir}"
}

# 根据关键字获取 CMakeLists.txt 设置项
function get_set_info_by_keyword()
{
    key_word="$1"
    target_line=$(cat ${cmake_source_dir}/CMakeLists.txt | grep "set(${key_word}.*)")
    echo $target_line
}

# 获取TARGET_NAME
function get_target_name()
{
    target_line=$(get_set_info_by_keyword "TARGET_NAME")
    target_name=${target_line##* }
    target_name=${target_name%%)*}
    write_to_file "target_name=${target_name}"
}

# 获取TARGET_NAME
function get_lib_name()
{
    lib_name_line=$(get_set_info_by_keyword "LIB_NAME")
    lib_name=${lib_name_line##* }
    lib_name=${lib_name%%)*}
    write_to_file "lib_name=lib${lib_name}"
}

# 获取路径设置
function get_path()
{
    line="${1}"
    target_path=${line##*/}
    target_path=${target_path%%)*}
    echo "${target_path}"
}

# 获取可执行文件的路径
function get_executable_output_path()
{
    output_path_line=$(get_set_info_by_keyword "EXECUTABLE_OUTPUT_PATH")
    executable_output_path=$(get_path "${output_path_line}")
    write_to_file "executable_output_path=${executable_output_path}"
}

function get_library_output_path()
{
    library_output_path_line=$(get_set_info_by_keyword "LIBRARY_OUTPUT_PATH")
    library_output_path=$(get_path "${library_output_path_line}")
    write_to_file "library_output_path=${library_output_path}"
}

# 获取CMake中间件的生成路劲
function get_buildcache_path()
{
    buildcache_line=$(get_set_info_by_keyword "BUILDCACHE_PATH")
    buildcache_path=$(get_path "${buildcache_line}")
    write_to_file "buildcache_path=${buildcache_path}"
}

function get_os_type
{
    os=$(uname -a|awk '{print $1}')
    os=${os%_*}
    if [[ ${os} == "MINGW"* ]]; then
        os="Windows"
    elif [[ ${os} == "Linux"* ]];then
        os="Linux"
    else
        echo "Error"
        return 1
    fi
    write_to_file "os=${os}"
}

create_new_file_and_del_old ${file_name}
get_os_type
get_cmake_source_dir
get_target_name
get_lib_name
get_executable_output_path
get_library_output_path
get_buildcache_path
