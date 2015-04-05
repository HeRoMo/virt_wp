#
# Cookbook Name:: virt_wp
# Recipe:: lamp
#
# Copyright (C) 2015 HeRo
#
# All rights reserved - Do Not Redistribute
#

e = execute "yum makecache" do
  action :nothing
end
e.run_action(:run)

Chef::Log.info "### MySQL Install ###"

### パッケージのインストール。
packages = ['httpd', 'httpd-devel','php', 'php-devel','php-mysql']
packages.each do |pkg|
  package pkg do
    action :install
  end
end

### MySQL のインストール
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

service "httpd" do
  supports :restart => true, :reload => true
  action [:enable,:start]
end
