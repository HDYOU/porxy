#!/bin/bash

export HOME="$(cd "`dirname "$0"`"/..; pwd)"
export DATA_HOME="$(cd "`dirname "$0"`"; pwd)"

all_proxy_file="${DATA_HOME}/all_proxy.txt"
api_proxy_file="${DATA_HOME}/api_proxy.txt"

validate_proxy(){
    __proxy_file="$1"
    sed -i '/^$/d' $__proxy_file
    count=`grep -v '^!' ${__proxy_file} | wc -l`
    if [ $count -le 1 ]; then
      echo "${__proxy_file} 代理为空"
      echo "" > ${__proxy_file}
    else
      echo "" >> ${__proxy_file}
    fi
}
echo "validate_proxy ..."
validate_proxy "${all_proxy_file}"
validate_proxy "${api_proxy_file}"