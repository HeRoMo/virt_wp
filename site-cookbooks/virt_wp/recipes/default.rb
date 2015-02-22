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
packages = ['tree','vim','unzip']
packages.each do |pkg|
  package pkg do
    action :install
  end
end
