#!/usr/bin/env bash

# set -e

export HOME="$(cd "`dirname "$0"`"/..; pwd)"
export DATA_HOME="$(cd "`dirname "$0"`"; pwd)"


pcount=$#
echo "pcount: ${pcount}"
if ((pcount < 1)); then
  echo no args
fi

echo  "正在对URL文件轮行去重处理."

proxy_file="$1"
tmp_proxy_file="${DATA_HOME}/tmp_proxy_url.list"
tmp_sort_proxy_file="${DATA_HOME}/tmp_sort_proxy_url.list"
cp -f $proxy_file $tmp_proxy_file

sed -i '/^$/d' $tmp_proxy_file
sed -i '/^#/d' $tmp_proxy_file
sort $tmp_proxy_file | uniq > $tmp_sort_proxy_file
mv -f $tmp_sort_proxy_file $tmp_proxy_file

echo  "URL文件轮行去重完成."
echo  "\n\n${proxy_file}:"
cat $proxy_file
echo  "\n\n${tmp_proxy_file}:"
cat $tmp_proxy_file

all_md_file="${DATA_HOME}/no_code_proxy.txt"

tmp_file="$DATA_HOME/tmp_md_proxy.txt"

for ip in `cat ${tmp_proxy_file}`
do
    echo  "正在下载: $ip"
    url="${ip}"
    echo  "url: ${url}"
    wget --no-check-certificate -t 3 -T 5 -O $tmp_file  ${url}

    if [ ! -f "$tmp_file" ]; then
            echo "$ip 下载失败！"
    else
            echo  "${ip} 下载成功,处理中..."
            awk '/trojan:\/\//' $tmp_file >> ${all_md_file}
            awk '/ss:\/\//' $tmp_file  >> ${all_md_file}
            awk '/ssr:\/\//' $tmp_file >> ${all_md_file}
            ##awk '/vmess:\/\//' $tmp_file >> ${all_md_file}
    fi
done

rm -f $tmp_file
rm -f $tmp_proxy_file

exit 0
