#!/bin/bash
source ./public_shell_func.sh
print_log "Start init enviriment!"
./create_config_file.sh
./copy_sys_cfg_files.sh
./copy_upadte_files.sh
result_log 0 "Init enviriment"
