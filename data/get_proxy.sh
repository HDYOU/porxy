#!/usr/bin/env bash

export HOME="$(cd "`dirname "$0"`"/..; pwd)"
export DATA_HOME="$(cd "`dirname "$0"`"; pwd)"

# 后端 URL
proxy_api_host="https://sub.xeton.dev"
proxy_api_url_part="/sub?target=clash&list=true&url="

pcount=$#
echo "pcount: ${pcount}"
if ((pcount < 1)); then
  echo no args
fi

echo -e "正在对URL文件轮行去重处理."

proxy_file="$1"
tmp_proxy_file="${DATA_HOME}/tmp_proxy_url.list"
tmp_sort_proxy_file="${DATA_HOME}/tmp_sort_proxy_url.list"
cp -f $proxy_file $tmp_proxy_file

sed -i '/^$/d' $tmp_proxy_file
sed -i '/^#/d' $tmp_proxy_file
sort $tmp_proxy_file | uniq > $tmp_sort_proxy_file
mv -f $tmp_sort_proxy_file $tmp_proxy_file

echo -e "URL文件轮行去重完成."
echo -e "\n\n${proxy_file}:"
cat $proxy_file
echo -e "\n\n${tmp_proxy_file}:"
cat $tmp_proxy_file

all_proxy_file="${DATA_HOME}/all_proxy.txt"
api_proxy_file="${DATA_HOME}/api_proxy.txt"

tmp_file="$DATA_HOME/tmp_proxy.txt"

write_to_file(){
  echo "" >> "$1"
  cat "$tmp_file" >> "$1"
  # 清除内容
  echo "" > "$tmp_file"
}

for ip in `cat ${tmp_proxy_file}`
do
    echo -e "正在下载: $ip"
    url="${proxy_api_host}${proxy_api_url_part}${ip}"
    echo -e "url: ${url}"
    wget --no-check-certificate -t 3 -T 5 -O "$tmp_file"  "${url}"

    if [ ! -f "$tmp_file" ]; then
            echo "$ip 下载失败！"
    else
            echo -e "${ip} 下载成功,处理中..."
            # 删除空行
            sed -i '/^$/d' $tmp_file
            # 错误信息
            # sed -i '/^The following link doesn/d'   $tmp_file
            # 删除代理头
            sed -i '/^proxies:/d'   $tmp_file

            # 错误信息
            match=$(grep "The following link does" $tmp_file)
            echo -e "match:\n $match"
            if [ -n "$match" ]; then
              echo "" > $tmp_file
            fi

            # 没有流量的节点
            match=$(grep "剩余流量：0 B" $tmp_file)
            echo -e "match:\n $match"
            if [ -n "$match" ]; then
              echo "" > $tmp_file
            fi
            # 没有流量的节点
            match=$(grep "剩余流量：0 GB" $tmp_file)
            echo -e "match:\n $match"
            if [ -n "$match" ]; then
              echo "" > $tmp_file
            fi

            match=$(grep "距离下次重置剩余" $tmp_file)
            echo -e "match:\n $match"
            if [ -n "$match" ]; then
              # API 节点，排除，在Github中无法测试
              write_to_file ${api_proxy_file}
            fi
            # 泡泡狗 节点
            match=$(grep "泡泡狗" $tmp_file)
            if [ -n "$match" ]; then
              write_to_file ${api_proxy_file}
            fi

            write_to_file ${all_proxy_file}
    fi
done

rm -f $tmp_file
rm -f $tmp_proxy_file

exit 0
