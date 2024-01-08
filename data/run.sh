#!/usr/bin/env bash

export HOME="$(cd "`dirname "$0"`"/..; pwd)"
export DATA_HOME="$(cd "`dirname "$0"`"; pwd)"

sh ${HOME}/data/init.sh

rules_path="${HOME}/rules"
rm -rf ${rules_path}
mkdir -p ${rules_path}
cd ${rules_path}

###################### 从 readme 读取 v2ray 格式的代理
sh ${DATA_HOME}/readme_proxy.sh "${DATA_HOME}/readme.list"

###################### 网站解析 代理URL，内容是加密的 v2ray / clash
echo "" > clashx.url
wget --no-check-certificate -t 3 -T 5 -O clashx.html  https://clashx.org/clashx-node/
awk '/https:\/\/www.qilin2.com\/api\//' clashx.html | awk '{ print $1"&rename=%60$@%20-%20ClashX节点%60" }' >> clashx.url
#sed -i -e 's/^/https:\/\/sub.xeton.dev\/sub?target=clash\&list=true\&url=/' clashx.url

###   snakem982/proxypool 代理池发布信息
wget --no-check-certificate -t 3 -T 5 -O README.md  https://raw.githubusercontent.com/snakem982/proxypool/main/README.md
echo "" >> clashx.url
echo "proxy pool : "
awk '/https:\/\/raw./' README.md
awk '/https:\/\/raw./' README.md | grep ".txt$"
awk '/https:\/\/raw./' README.md | grep ".txt$" | sed 's/https:\/\/ghproxy.com\///'
awk '/https:\/\/raw./' README.md | grep ".txt$" | sed 's/https:\/\/ghproxy.com\///' | sed 's/https:\/\/github.moeyy.xyz\///'
awk '/https:\/\/raw./' README.md | grep ".txt$" | sed 's/https:\/\/ghproxy.com\///' | sed 's/https:\/\/github.moeyy.xyz\///' | awk '{ print $1"?&_t=1&rename=%60$@%20-%20ProxyPool代理池%60"}' >> clashx.url

echo -e "\n\n\n clashx.url  \n"
cat clashx.url
## 执行解析
sh ${HOME}/data/get_proxy.sh clashx.url


# data 获取 data 代理
sh ${HOME}/data/get_proxy.sh ${HOME}/data/proxy.list
sh ${HOME}/data/validate_proxy.sh


###################### 测速
cd ${rules_path}
############### v2ray 格式的代理测试, 没有加密
filename="no_code_proxy.txt"
cp -f "${HOME}/data/${filename}" "${filename}"
${HOME}/data/test_proxy.sh "${filename}"

############### yaml 格式的代理测试
filename="all_proxy.txt"
cp -f "${HOME}/data/${filename}" "${filename}"
${HOME}/data/test_proxy.sh "${filename}"

## API 代理转换成 v2ray
#cp -f ../data/api_proxy.txt api_proxy.txt

################### 合并代理
cd "${HOME}"
echo -e "\n\n\n combine \n"
ls -ls rules/*.txt
wc -l rules/*.txt
echo "" > combine.txt
#cat rules/*.txt
cat rules/*.txt >> combine.txt
wc -l combine.txt
# find rules -mtime 0 -a -name '*.txt' -type f -exec cat {} \;
# find rules -mtime 0 -a -name '*.txt' -type f -exec cat {} \; > combine.txt
base64 --wrap=0 combine.txt > combine.base64

# 删除
rm -rf ${HOME}/lite ${HOME}/data/lite
rm -rf ${HOME}/rules/*.md ${HOME}/rules/*.html ${HOME}/rules/tmp_*
rm -rf ${HOME}/rules/tmp_*
rm -rf .wget-hsts **/.wget-hsts **/**/.wget-hsts
rm -rf 0 **/0 **/**/0