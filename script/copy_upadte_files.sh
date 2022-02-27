#!/bin/bash
source ./public_config.sh
source ./public_shell_func.sh

cp -rf ${platform_dir}/update/* ${cmake_source_dir}/
if [ -e ${platform_dir}/update/.vscode ]; then
    cp -rf ${platform_dir}/update/.vscode/* ${cmake_source_dir}/.vscode/
fi

result_log 0 "update files"
