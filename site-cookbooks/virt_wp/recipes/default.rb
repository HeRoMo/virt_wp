#
# Cookbook Name:: virt_wp
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

e = execute "yum makecache" do
  action :nothing
end
e.run_action(:run)

# パッケージのインストール。
packages = ['tree','vim', 'httpd', 'httpd-devel','php', 'php-devel','php-mysql','unzip']
packages.each do |pkg|
  package pkg do
    action :install
  end
end


### MySQL のインストール
Chef::Log.info "### MySQL Install ###"
mysql_service 'default' do
  port '3306'
  version node[:mysql][:version]
  initial_root_password node[:mysql][:root_password]
  action [:create, :start]
end

# mysql_config 'default' do
#   source 'mysite.cnf.erb'
#   notifies :restart, 'mysql_service[default]'
#   action :create
# end

### wordpress のインストール
wp = "wordpress-4.1.1-ja"
wp_archive = "#{wp}.zip"
wp_dl_url ="https://ja.wordpress.org/#{wp_archive}"

work_dir = "/usr/local/src"

directory work_dir do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file "#{work_dir}/#{wp_archive}" do
  source wp_dl_url
end

#### WP用データベースの作成
template "#{work_dir}/init_wordpress_db.sql" do
  source 'mysql/init_wordpress_db.sql.erb'
end

bash 'create_wordpress_db' do
  user 'root'
  code <<-EOC
    mysql -h 127.0.0.1 -u root -p#{node[:mysql][:root_password]} < #{work_dir}/init_wordpress_db.sql
    touch #{work_dir}/init_wordpress_db
  EOC
  creates "#{work_dir}/init_wordpress_db"
end

bash 'deploy wordpress' do
  user 'root'
  cwd work_dir
  code <<-EOC
    unzip #{wp}
    mv wordpress /var/www/html/
    chown -R apache:apache /var/www/html/wordpress
  EOC
  creates "/var/www/html/wordpress"
end

template '/var/www/html/wordpress/wp-config.php' do
  source 'wordpress/wp-config.php.erb'
end

service "httpd" do
  supports :restart => true, :reload => true
  action [:enable,:start]
end