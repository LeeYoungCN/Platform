#!/bin/bash

function create_new_file()
{
    touch ${1}
    chmod 777 ${1}
}

function create_new_file_if_not_exist()
{
    if [ ! -e ${1} ]; then
       return
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
