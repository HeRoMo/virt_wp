
# MySQL Setting
default[:mysql][:version] = '5.6'
default[:mysql][:root_password] = 'mysqlpswd'

# Wordpress Setting
default[:wordpress][:db_name] = 'wordpress'
default[:wordpress][:db_user] = 'wp_user'
default[:wordpress][:db_password] = 'wp_pswd'