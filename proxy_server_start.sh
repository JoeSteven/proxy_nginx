# mac get ip :ps -ef | grep -i docker | grep -i  "\-\-host\-ip" |awk -F "host-ip" '{print $2}' | awk -F '--lowest-ip' '{print $1}'
# linux : ifconfig | grep docker -A 8
HOST_MACHINE_IP=xxx.xxx.xxx.xxx
origin_config_folder="./conf.origin"
build_config_folder="./conf.d"
ABSOLUTE_CONFIG_PATH="your_real_path/proxy_nginx/conf.d"
NGINX_REPELACE_PATH="/etc/nginx/conf.d"
NGINX_IMAGE_VERSION="nginx:alpine"
DOCKER_CONTAINER_NAME="proxyserver"

echo "容器可访问的宿主IP为:$HOST_MACHINE_IP"
echo "Start Proxyserver..."
echo "Host ip is $HOST_MACHINE_IP"

echo "Build config..."
#删除build文件夹中的所有文件
if [ ! -d "$build_config_folder" ];then
  echo "create $build_config_folder"
  mkdir $build_config_folder
else
  echo "$build_config_folder already exists"
fi
echo "remove all files in $build_config_folder"
rm -rf $build_config_folder/*

# 读取所有的nginx子项目配置文件
originConfigFiles=$(ls $origin_config_folder)
for originConfig in $originConfigFiles
do
  echo "==========>Read config $originConfig and write into $build_config_folder"
  cp $origin_config_folder/$originConfig $build_config_folder/$originConfig
  echo "replace \${HOST_MACHINE_IP} to $HOST_MACHINE_IP"
  sed -i "" "s/\${HOST_MACHINE_IP}/$HOST_MACHINE_IP/g" $build_config_folder/$originConfig
done
echo "Build config success!"

#检查是否已经有相同容器，有就重启容器，否则启动新容器
result=`docker container ls -a`
if [[ $result =~ "$DOCKER_CONTAINER_NAME" ]]
then
  echo "$DOCKER_CONTAINER_NAME already exists, try restart "
  docker container restart $DOCKER_CONTAINER_NAME
else
  echo "$DOCKER_CONTAINER_NAME not exists, start new one "
  docker run --name $DOCKER_CONTAINER_NAME -d -p 80:80  -v $ABSOLUTE_CONFIG_PATH:$NGINX_REPELACE_PATH $NGINX_IMAGE_VERSION
fi
echo "Done!"
