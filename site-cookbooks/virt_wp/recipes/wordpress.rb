#
# Cookbook Name:: virt_wp
# Recipe:: wordpress
#
# Copyright (C) 2015 HeRo
#
# All rights reserved - Do Not Redistribute
#

### wordpress のインストール
Chef::Log.info "### Wordpress Install ###"

wp = "wordpress-4.1.1-ja"
wp_archive = "#{wp}.zip"
wp_dl_url ="https://ja.wordpress.org/#{wp_archive}"
work_dir = "/usr/local/src"

### 作業ディレクトリの作成
directory work_dir do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

### WP用データベースの作成
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

### Wordpress のダウンロード
remote_file "#{work_dir}/#{wp_archive}" do
  source wp_dl_url
end

### Wordpress の配置と設定
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
