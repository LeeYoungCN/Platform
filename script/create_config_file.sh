#!/bin/bash
source ./public_shell_func.sh
platform_script_path=$(pwd)

source_path=$(cd ../..; pwd)
save_path=$(platform_script_path)

file_name=public_config.sh

if [ $# -ge 2 ]; then
    source_path=$(cd $1;pwd)
    save_path=$(cd $2;pwd)
fi

# 写入public_config.sh 文件
function write_to_file()
{
    echo ${1}
    echo ${1} >> ${save_path}/${file_name}
}

# 获取CMakeList.txt所在路径
function get_cmake_source_dir()
{
    write_to_file "cmake_source_dir=${source_path}"
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

# 获取LIB_NAME
function get_lib_name()
{
    lib_name_line=$(get_set_info_by_keyword "LIB_NAME")
    lib_name=${lib_name_line##* }
    lib_name=${lib_name%%)*}
    write_to_file "lib_name=lib${lib_name}"
}

# 提取路径
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

# 获取库文件的生成路径
function get_library_output_path()
{
    library_output_path_line=$(get_set_info_by_keyword "LIBRARY_OUTPUT_PATH")
    library_output_path=$(get_path "${library_output_path_line}")
    write_to_file "library_output_path=${library_output_path}"
}

# 获取CMake中间件的生成路径
function get_buildcache_path()
{
    buildcache_line=$(get_set_info_by_keyword "BUILDCACHE_PATH")
    buildcache_path=$(get_path "${buildcache_line}")
    write_to_file "buildcache_path=${buildcache_path}"
}

# 获取操作系统类型
function get_os_type
{
    os=$(uname -s)
    os=${os%_*}
    if [[ ${os} == "MINGW"* ]]; then
        os="Windows"
    elif [[ ${os} == "Linux"* ]]; then
        os="Linux"
    elif [[ ${os} == "Darwin"* ]]; then
        os="MacOS"
    else
        result_log 1 "get os"
        return 1
    fi
    write_to_file "os=${os}"
    return 0
}

create_new_file_and_del_old ${save_path}/${file_name}
get_os_type
get_cmake_source_dir
get_target_name
get_lib_name
get_executable_output_path
get_library_output_path
get_buildcache_path
result_log 0 "create config file"
