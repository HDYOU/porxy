#!/usr/bin/env bash

# set -e

export HOME="$(cd "`dirname "$0"`"/..; pwd)"
export DATA_HOME="$(cd "`dirname "$0"`"; pwd)"

# 后端 URL
proxy_api_host="https://pub-api-1.bianyuan.xyz"
#  rename `111@222`
rename_part="&rename=%60,@%20%60%60%EF%BC%8C@%20%60"
target_url="https://raw.githubusercontent.com/HDYOU/porxy/main/combine.base64"
proxy_config_url="https://raw.githubusercontent.com/HDYOU/ClashADRule/main/ACL4SSR_Online_AdblockPlus.ini"
fileter_part="&exclude=%E5%9B%BD%E5%A4%96%E7%9B%B4%E8%BF%9E|%E5%9B%BD-%3E|%E5%8F%B0%E6%B9%BE%E6%B7%B7%E5%90%88|%F0%9F%93%A1%20PING-&include=%F0%9F%87%A8%F0%9F%87%B3|%E4%B8%AD%E5%9B%BD|%E5%AE%89%E5%BE%BD%E7%9C%81|%E7%A7%BB%E5%8A%A8|%E8%81%94%E9%80%9A|%E7%94%B5%E4%BF%A1|%E5%8F%B0%E6%B9%BE|Taiwan|%F0%9F%87%AD%F0%9F%87%B0|%E9%A6%99%E6%B8%AF|%F0%9F%87%AF%F0%9F%87%B5|%E6%97%A5%E6%9C%AC|%F0%9F%87%B8%F0%9F%87%AC|%E6%96%B0%E5%8A%A0%E5%9D%A1|Singapore|%F0%9F%87%B0%F0%9F%87%B7|%E9%9F%A9%E5%9B%BD|%E7%BE%8E%E5%9B%BD|ChatGPT%E8%A7%A3%E9%94%81|%E7%BA%BF%E8%B7%AF|henet.uk|%E7%94%B5%E6%8A%A5%E7%BE%A4|%E5%85%B3%E6%B3%A8|%E5%BB%B6%E6%9C%9F|%E6%B5%81%E9%87%8F|%E9%87%8D%E7%BD%AE|henet.uk|%E5%85%8D%E8%B4%B9%E8%8A%82%E7%82%B9&"
proxy_api_url_part="/sub?config=$proxy_config_url&emoji=true&fdn=true&scv=true&sort=false&tfo=false&url=${target_url}${rename_part}"


base_path="${HOME}/rules"
mkdir -p $base_path

#################################  clash
echo "Gen clash config:"
tmp_file="${base_path}/github-clash.yaml"
url="${proxy_api_host}${proxy_api_url_part}${fileter_part}&target=clash"
wget --no-check-certificate -t 3 -T 5 -O "$tmp_file" "${url}"

tmp_file="${base_path}/github-clash-all.yaml"
url="${proxy_api_host}${proxy_api_url_part}&target=clash"
wget --no-check-certificate -t 3 -T 5 -O "$tmp_file" "${url}"


#################################  surfboard
echo "Gen surfboard config:"
file_name="github-surfboard.conf"
tmp_file="${base_path}/${file_name}"
url="${proxy_api_host}${proxy_api_url_part}${fileter_part}&target=surfboard"
wget --no-check-certificate -t 3 -T 5 -O "$tmp_file" "${url}"

# 替换头部
sed -i '/#!MANAGED-CONFIG/d' ${tmp_file}
sed -i '1i #!MANAGED-CONFIG https://mirror.ghproxy.com/https://raw.githubusercontent.com/HDYOU/porxy/main/rules/github-surfboard.conf interval=86400 strict=true' ${tmp_file}

echo "Gen surfboard config:"
file_name="github-surfboard-all.conf"
tmp_file="${base_path}/${file_name}"
url="${proxy_api_host}${proxy_api_url_part}&target=surfboard"
wget --no-check-certificate -t 3 -T 5 -O "$tmp_file" "${url}"

# 替换头部
sed -i '/#!MANAGED-CONFIG/d' ${tmp_file}
sed -i '1i #!MANAGED-CONFIG https://mirror.ghproxy.com/https://raw.githubusercontent.com/HDYOU/porxy/main/rules/github-surfboard-all.conf interval=86400 strict=true' ${tmp_file}


