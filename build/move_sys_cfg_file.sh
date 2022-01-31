#!/bin/bash
source ./public_config.sh

# 刷新launch.json可执行文件的路径
function set_exe_path_in_launch()
{
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
    sed -i ${command} launch.json
    popd >> /dev/null
}

cp -rf ./../os_cfg/${os}/* ${cmake_source_dir}/
cp -rf ./../os_cfg/${os}/.vscode/* ${cmake_source_dir}/.vscode/
set_exe_path_in_launch
