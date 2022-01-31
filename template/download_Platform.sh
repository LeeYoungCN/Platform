#!/bin/bash
function copy_tmplate_file()
{
    file_name="${1}"
    file_name=${file_name#${template_path}\/}
    if [ ! -e ${root}/${file_name} ];then
        cp -rf ${template_path}/${file_name} ${root}/${file_name}
    fi
}

function copy_all_file()
{
    for f in $(ls -a $1); do
        if [ ${f} == "." -o ${f} == ".." ]; then
            continue
        fi
        if [ -d ${f} ]; then
            copy_all_file "${1}/${f}"
        else
            copy_tmplate_file "${1}/${f}"
        fi
    done
}

if [ -d Platform ]; then
    rm -rf Platform
fi

git clone git@github.com:LeeYoungCN/Platform.git

root=$(pwd)
platform_path=$(cd Platform;pwd)
template_path="${platform_path}/template"
cd ${platform_path}/build
./init_env.sh
cd ${root}

if [ ! -d ${root}/.vscode ]; then
    mkdir -p ${root}/.vscode
fi

copy_all_file ${template_path}
