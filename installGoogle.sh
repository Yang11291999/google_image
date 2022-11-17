# 虚拟机版本：RHEL8.4

#下载和解压所需安装包
   yum install -y git  gcc gcc-c++  make
   yum install -y wget
   wget http://nginx.org/download/nginx-1.7.8.tar.gz
   wget https://udomain.dl.sourceforge.net/project/pcre/pcre/8.38/pcre-8.38.tar.gz
   wget https://www.openssl.org/source/openssl-1.0.1j.tar.gz
   wget https://zlib.net/fossils/zlib-1.2.11.tar.gz
   git clone https://github.com/cuber/ngx_http_google_filter_module
   git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
   tar xzvf nginx-1.7.8.tar.gz 
   tar xzvf pcre-8.38.tar.gz 
   tar xzvf openssl-1.0.1j.tar.gz 
   tar xzvf zlib-1.2.11.tar.gz
#进入nginx目录
   cd nginx-1.7.8

# 配置
   ./configure --prefix=/opt/nginx-1.7.8 --with-pcre=../pcre-8.38 --with-openssl=../openssl-1.0.1j --with-zlib=../zlib-1.2.11 --with-http_ssl_module --add-module=../ngx_http_google_filter_module --add-module=../ngx_http_substitutions_filter_module
#解决版本差异问题，如centos7不需要该步骤
#    vi src/os/unix/ngx_user.c # 因版本问题修改参数，已保存副本，直接上传

#编译
   make
#安装
   make install

   /opt/nginx-1.7.8/sbin/nginx -t #测试是否能启动nginx

#    vi /opt/nginx-1.7.8/conf/nginx.conf # 修改ip和代理等，已保存副本，直接上传即可，修改server中ip和location / {} 的代理
wget -P /opt/nginx-1.7.8/conf   # 通过下载模板文件，然后修改ip本机
ip=`curl http://metadata.tencentyun.com/meta-data/public-ipv4` #获取本机公网ip
   /opt/nginx-1.7.8/sbin/nginx -c /opt/nginx-1.7.8/conf/nginx.conf #指定nginx配置文件
#第一种 杀掉nginx重新启动
#    netstat -ntlp
#    kill -9 95381 #ID要改
#    netstat -ntlp

#第二种 停止nginx 进程
   /opt/nginx-1.7.8/sbin/nginx -s stop

# 重新启动
   /opt/nginx-1.7.8/sbin/nginx -c /opt/nginx-1.7.8/conf/nginx.conf
#重载
   /opt/nginx-1.7.8/sbin/nginx -s reload

#打开80端口
   systemctl stop firewalld.service
   systemctl start firewalld.service
   systemctl status firewalld.service
   firewall-cmd --list-all
   firewall-cmd --add-service=http --permanent
   firewall-cmd --add-port=80/tcp --permanent # 打开80端口
   firewall-cmd --reload
   firewall-cmd --list-all
