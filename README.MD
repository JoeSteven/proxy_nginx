### proxy_server_start.sh使用须知

使用前请确认已经安装docker

1.替换ABSOLUTE_CONFIG_PATH="/Users/mimao/WebServer/proxy_nginx/conf.d" 为实际路径

2.替换HOST_MACHINE_IP=192.168.65.2 为docker可以访问的实际宿主主机IP

3.每个项目的.conf文件放在 conf.origin 目录下，且将proxy_pass 中宿主主机IP用${HOST_MACHINE_IP}占位，文件命名规范为:项目名称_ 域名_端口号.conf, 每个项目配置文件中proxy_pass所声明的端口应该与该项目的docker容器所映射的宿主端口一致。例如`docker run -p 8080:80 ...` `， conf中proxy_pass的端口即为8080 

4.执行`./proxy_server_start.sh` ,如果提示没有权限，执行`sudo chmod 764 proxy_server_start.sh`

**注意：每次修改conf.origin目录中的文件后都需要执行该脚本**

