#!/usr/bin/env bash

# set -e

export HOME="$(cd "`dirname "$0"`"/..; pwd)"
export DATA_HOME="$(cd "`dirname "$0"`"; pwd)"

pcount=$#
echo "pcount: ${pcount}"
if ((pcount < 1)); then
  echo no args
fi

file_path="$1"
#2 获取文件名称
f_name=$(basename "${file_path}")

#3 获取上级目录到绝对路径
p_dir=$(
  cd -P "$(dirname "${file_path}")" || exit 0
  pwd
)

lite_path="$DATA_HOME/lite"
lite_file_path="$lite_path/lite"
lite_file_config_path="$lite_path/config.json"
lite_url="https://github.com/HDYOU/LiteSpeedTest/releases/download/v0.15.1/lite-linux-amd64-v0.15.1.gz"
if [ ! -f $lite_file_path ]; then

    DOWNLOAD_URL=$(curl -s https://api.github.com/repos/HDYOU/LiteSpeedTest/releases/latest \
        | grep browser_download_url \
        | grep linux-amd64 \
        | grep -v v3- \
        | cut -d '"' -f 4)
    echo "lite 下载链接： $DOWNLOAD_URL"
    mkdir -p $lite_path
    cd $lite_path
    rm -f *
    wget -O lite-linux-amd64.gz $DOWNLOAD_URL
    gzip -d lite-linux-amd64.gz
    ls -ls
    mv -f lite-linux* lite
    chmod 777 lite

    #       "speedtestMode":"pingonly", // speedonly pingonly all
    #       "pingMethod":"googleping",  // googleping tcpping
    #       "sortMethod":"rspeed",      // speed rspeed ping rping
    #       "concurrency":1,  // concurrency number
    #       "testMode":2,   // 2: ALLTEST 3: RETEST
    #       "subscription":"subscription url",
    #       "timeout":16,  // timeout in seconds
    #       "language":"en", // en cn
    #       "fontSize":24,
    #       "unique": true,  // remove duplicated value
    #       "theme":"rainbow",
    #       "outputMode": 1  // 0: base64 1: pic path 2: no pic 3: json 4: txt
    #       "outputMode": 1  // 0: base64 1: pic path 2: no pic 3: json 4: txt
    echo '{"group":"job","speedtestMode":"all","pingMethod":"googleping","sortMethod":"rspeed","concurrency":20,"testMode":2,"subscription":"","timeout":16,"language":"en","fontSize":24,"theme":"rainbow","unique":true,"outputMode":4}' > $lite_file_config_path

    cd $DATA_HOME
fi


file_path="${p_dir}/${f_name}"
echo "file path: ${file_path}"
wc -l ${file_path}

if [ -s $file_path ]; then
  echo "$file_path 文件不为空"
else
  echo "$file_path 文件为空"
  exit 0
fi

# 切换目录
cd "$p_dir" || exit 0
echo "条目数"
wc -l ${file_path}
echo ""
echo ""
# echo "内容："
# cat ${file_path}
echo ""
echo ""
$lite_file_path --config ${lite_file_config_path} --test ${file_path}
mv -f output.txt ${file_path}
rm -f output.txt

echo "" >> ${file_path}
echo ""
echo "更新之后的条目数："
wc -l ${file_path}
echo ""
echo ""

# base64 编码
base64_file_path="${p_dir}/${f_name%.*}.base64"
base64 --wrap=0 "${file_path}" > "${base64_file_path}"

exit 0
