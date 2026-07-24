#!/bin/bash

# set -e

export HOME="$(cd "`dirname "$0"`"/..; pwd)"
export DATA_HOME="$(cd "`dirname "$0"`"; pwd)"

all_proxy_file="${DATA_HOME}/all_proxy.txt"
api_proxy_file="${DATA_HOME}/api_proxy.txt"
echo "proxies:" > ${all_proxy_file}
echo "proxies:" > ${api_proxy_file}


all_md_file="${DATA_HOME}/no_code_proxy.txt"
echo "" > ${all_md_file}