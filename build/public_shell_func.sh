#!/bin/bash
function print_log()
{
    d=$(date "+%Y-%m-%d %H:%M:%S")
    echo "${d} ${1}"
}

function result_log()
{
    if [ $1 -eq 0 ]; then
        print_log "$2 success!"
    else
        print_log "$2 fail!"
    fi
}

function create_new_file()
{
    touch ${1}
    chmod 777 ${1}
}

function create_new_file_if_not_exist()
{
    if [ ! -e ${1} ]; then
       return 1
    fi

    create_new_file ${1}
}

# 创建文件
function create_new_file_and_del_old()
{
    if [ -e ${1} ];then
        rm -rf ${1}
    fi
    create_new_file ${1}
}

function create_new_folder_and_del_old()
{
    if [ -d ${1} ];then
        rm -rf ${1}
    fi
    mkdir -p ${1}
}

# 刷新launch.json可执行文件的路径
function set_exe_path_in_launch()
{
    if [ $# -gt 0 ];then
        target_name="${1}"
    fi

    pushd ${cmake_source_dir}/.vscode >> /dev/null
    key="\"program\""
    value="${executable_output_path}/${target_name}"
    if [ "${os}" == "Windows" ]; then
        value="${value}.exe"
    fi
    old_line=$(cat launch.json | grep "${key}.*")
    old_line=${old_line##*\{workspaceFolder\}\/}
    old_line=${old_line%%\",*}
    command="s#${old_line}#${value}#g"

    if [ "$(uname -s)" == "Darwin" ]; then
        sed -i "" ${command} launch.json
    else
        sed -i ${command} launch.json
    fi
    popd >> /dev/null
}
