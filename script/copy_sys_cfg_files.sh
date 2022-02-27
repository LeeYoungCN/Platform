#!/bin/bash
source ./public_config.sh
source ./public_shell_func.sh

cp -rf ${platform_dir}/os_cfg/${os}/* ${cmake_source_dir}/
cp -rf ${platform_dir}/os_cfg/${os}/.vscode/* ${cmake_source_dir}/.vscode/

if [ ${#target_name} -gt 0 ]; then
    set_exe_path_in_launch
fi
result_log 0 "copy cfg files"
