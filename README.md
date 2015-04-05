# virt_wp

Vagrant + Chef でWordpressの開発環境となる仮想サーバを作ります。

## 作成される環境

- CentOS 6.5
- Apache + PHP
- MySQL 5.6 (root パスワード: mysqlpswd)
− Wordpress 4.1.1
  - DB: wordpress
  - DB user: wp_user
  - DB pssword: wp_pswd

## 準備

次のものをインストールしてください。

- [Vagrant](https://www.vagrantup.com/downloads.html) 1.7以上
  - [vagrant-omnibus](https://github.com/chef/vagrant-omnibus)
- [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads) 4.3以上
- [Berkshelf](http://berkshelf.com/) 3.0以上

### Berkshelf のインストールについて

コミュニティクックブックを利用するのでBerkshelfのインストールが必要です。
下記の方法でインストールしたら次のコマンドを実行します。

 > berks vendor ./cookbooks

#### OSX,Linuxの場合

Gemfileを用意しているので Rubyをインストールしている環境では bundler でインストールできます。

```
> cd virt_wp  # Gemfile と Berksfileのあるディレクトリ
> bundle install
```

#### Windowsの場合

Rubyをインストールして、gem でBerkshelf をインストールするのはハマります。  
いろいろ試して、1日くらい試行錯誤してやっとインストールできても、
どの手順が有効なのかわからない再現性のない作業です。（あくまで私の経験です）

最近は次をインストールするとBerkshelfを含むchefがさくっとインストールできます。  
Rubyをインストールしておく必要もありません。
[ ChefDK | Chef Development Kit](https://downloads.chef.io/chef-dk/windows/#/)

## 操作

操作は Vagrantfile と同じディレクトリで行います。


#### 最初の起動の前に

最初の起動の前にBerksfileと同じディレクトリで次のコマンドを実行してください。  
cookbooksディレクトリ以下にコミュニティクックブックをダウンロードします。  
（cookbooksディレクトリの中を削除した場合も実行してください）

 > berks vendor ./cookbooks
 
### 起動
 
仮想サーバーを起動するには次のコマンドを実行します。

 > vagrant up
 
最初の起動はOSイメージのダウンロードと環境構築が走るので少し時間がかかります。

起動後は次のURLでWordpressにアクセスできます。

http://192.168.33.111/wordpress/

管理画面には次のURLでアクセスできます。

http://192.168.33.111/wordpress/wp-admin/

最初にアクセスするとサイトのインストールページが表示されます。
必要な情報を入力してインストールしてください。

### 再起動

仮想サーバを再起動するには次のコマンドを実行します。

```
 > vagrant reload
```

### 停止

仮想サーバを停止するには次のコマンドを実行します。

```
 > vagrant halt
```

### 再構築

環境を作りなおすときには一度破棄(destroy)して、再度 vagarnt up を実行します。

```
 > vagrant destroy
 > vagrant up
```
 
### SSHでログイン

仮想サーバにSSHで接続する場合には次のコマンドを実行します。

```
 > vagrant ssh
```

上記コマンドは次のアカウント/パスワードでログインするのと同じです。

- アカウント： vagrant
- パスワード： vagrant

ちなみにサーバのアドレスは 192.168.33.111 です。


