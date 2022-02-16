#!/bin/bash

git_ssh=""
git_user=""
git_repository=""
git_branch=""
git_zip=""
git_zip_link=""

function get_git_info()
{
    git_ssh="${1}"
    git_branch="${2}"
    git_user=${git_ssh#git@github.com:}
    git_user=${git_user%/*}
    git_repository=${git_ssh#*/}
    git_repository=${git_repository%*.git}
    git_zip="${git_repository}-${git_branch}.zip"
    git_zip_link="https://github.com/${git_user}/${git_repository}/archive/refs/heads/${git_branch}.zip"
}

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

function copy_tmplate_file()
{
    file_name="${1}"
    if [ ! -e ${root}/${file_name} ];then
        cp -rf ${template_path}${file_name} ${root}${file_name}
    fi
}

function copy_all_file()
{
    folder=${1}
    for file in $(find ${folder} -type f); do
        file_name=${file##${folder}}
        copy_tmplate_file "${file_name}"
    done
}

function backup_file()
{
    file="${1}"
    if [ -e ${file} ]; then
        mv -f "${file}" "${file}_backup"
    fi
}

function reset_from_backup()
{
    file="${1}"
    if [ -e "${file}_backup" ]; then
        mv -f "${file}_backup" "${file}"
    fi
}

function delete_backup()
{
    file="${1}"
    if [ -e "${file}_backup" ]; then
        rm -rf "${file}_backup"
    fi
}

function git_clone_repository()
{
    ssh_path="${1}"
    branch=${2}
    repository=${ssh_path#*/}
    repository=${repository%*.git}
    backup_file "${repository}"
    log_str="git clone ${ssh_path}"
    git clone "${ssh_path}"
    if [ $? -ne 0 ]; then
        result_log 1 "${log_str}"
        reset_from_backup "${repository}"
        return 1
    fi
    chmod -R 700 ${repository}
    pushd ./${repository}
    git checkout ${branch}
    popd
    result_log 0 "${log_str}"
    delete_backup "${repository}"
    return 0
}

function unzip_file()
{
    zip_file=${1}
    unzip_file=${2}
    log_str="unzip ${zip_file}"
    if [ ! -e ${zip_file} ]; then
        print_log "${zip_file} not exist!"
        return 1
    fi
    if [ -e ${unzip_file} ]; then
        backup_file "${unzip_file}"
    fi

    unzip -o ${zip_file} >> /dev/null
    if [ $? -eq 0 ]; then
        result_log 0 "${log_str}"
        mv -f "${zip_file%%.zip}" "${unzip_file}"
        chmod -R 700 "${unzip_file}"
        delete_backup "${unzip_file}"
        return 0
    fi
    result_log 1 "${log_str}"
    reset_from_backup ${unzip_file}
    return 1
}

function download_file()
{
    link="$1"
    target="$2"
    log_str="download ${target}"
    if [ -e ${target} ]; then
        backup_file ${target}
    fi
    wget -O ${target} ${link}
    if [ $? -ne 0 ]; then
        result_log 1 "${log_str}"
        rm -rm ${target}
        reset_from_backup ${target}
        return 1
    fi
    result_log 0 "${log_str}"
    delete_backup ${target}
    return 0
}

function get_platform()
{
    get_git_info "git@github.com:LeeYoungCN/Platform.git" "master"
    git_clone_repository "${git_ssh}" "${git_branch}"
    if [ $? -eq 0 ]; then
        return 0
    fi
    download_file ${git_zip_link} ${git_zip}
    unzip_file "${git_zip}" "${git_repository}"
    if [ $? -ne 0 ] && [ ! -e ${repository} ]; then
        exit
    fi
    return 0
}

get_platform
root=$(pwd)
platform_path=$(cd Platform;pwd)
template_path="${platform_path}/template"

if [ ! -d ${root}/.vscode ]; then
    mkdir -p ${root}/.vscode
fi

copy_all_file ${template_path}

cd ${platform_path}/build
./init_env.sh
cd ${root}
