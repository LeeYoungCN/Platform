#!/bin/bash
source ./public_shell_func.sh
print_log "Start init enviriment!"
./create_config_file.sh
./move_sys_cfg_file.sh
result_log 0 "Init enviriment"
