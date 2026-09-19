#!/usr/bin/env bash

# set -e

# 解析 https://nodefree.org/dy/2024/05/20240519.txt
# 解析 包含日期链接的订阅节点

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

replace_date_val(){
        file_path=$1
        tmp_date=$2
        yyyyMMdd=$(date -d "$tmp_date" +'%Y%m%d')
        yyyy=$(date -d "$tmp_date" +'%Y')
        MM=$(date -d "$tmp_date" +'%m')
        dd=$(date -d "$tmp_date" +'%d')
        sed -i s"/#yyyy#/${yyyy}/g"  "$file_path"
        sed -i s"/#MM#/${MM}/g"  "$file_path"
        sed -i s"/#dd#/${dd}/g"  "$file_path"
        echo ""
        echo "替换之后的内容："
        cat "$file_path"
        echo ""
        echo ""
}

cur_date=$(TZ=UTC-8 date +'%Y-%m-%d')
yesterday_date=$(TZ=UTC-8 date --date="yesterday" +'%Y-%m-%d')

tmp_cur_date_proxy_file="${DATA_HOME}/tmp_cur_date_proxy_url.list"
tmp_yesterday_date_proxy_file="${DATA_HOME}/tmp_yesterday_date_proxy_url.list"

cp -f $tmp_proxy_file $tmp_cur_date_proxy_file
cp -f $tmp_proxy_file $tmp_yesterday_date_proxy_file

replace_date_val "$tmp_cur_date_proxy_file" "$cur_date"
replace_date_val "$tmp_yesterday_date_proxy_file" "$yesterday_date"


sh ${DATA_HOME}/get_proxy.sh "$tmp_cur_date_proxy_file"
sh ${DATA_HOME}/get_proxy.sh "$tmp_yesterday_date_proxy_file"


rm -f $tmp_proxy_file
rm -f $tmp_cur_date_proxy_file
rm -f $tmp_yesterday_date_proxy_file

exit 0
