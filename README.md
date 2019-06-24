# aws_ws_mfa_test
[SlideShare](https://www.slideshare.net/AmazonWebServicesJapan/amazon-workspaces-86568155)

Amazon WorkSpaces MFA 設定用のTerraform/piculet設定

# (Optional) Direnv 設定
[Direnv](https://github.com/direnv/direnv) を使ってローカルリポジトリのディレクトリ上でクレデンシャル情報を設定する。
Direnvの初期設定後、ローカルリポジトリのルートに .envrc ファイルを作成して以下のようにexport設定を記載する。各環境変数の意味については[AWS CLIドキュメント](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-envvars.html)参照。

```
export AWS_ACCESS_KEY_ID=xxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxx
export AWS_DEFAULT_REGION=xx-xxxxx-x
```

以下コマンドで .envrc に記載した変数設定を有効化する。

```
direnv allow
```

以下のAWS CLIコマンドを実行し、.enrvcで設定したアカウント/IAMユーザが表示されることを確認する。

```
aws sts get-caller-identity
```

# Terraform

## create EC2 Key pair

[Documents](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-services-ec2-keypairs.html)

EC2インスタンスに設定するキーペアをあらかじめ作成しておく(以下AWS CLIのコマンド)

```
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
```

## Setting
variables.tf を作成する。variables.tf_sampleを参考に項目を埋める

```
cp variables.tf_sample variables.tf
```

## Deploy

以下コマンドを実行し、Terraformで設定したリソースを展開する

```
cd aws_terraform
terraform init
terraform validate
terraform plan
terraform apply
```

2回目以降は以下コマンドを実行する。

```
terraform refresh
terraform validate
terraform plan
terraform apply
```

# piculet
[piculet](https://github.com/codenize-tools/piculet) でセキュリティーグループを設定する

## Prepare

### Install piculet

piculet をインストールしていない場合はBundlerを使って以下コマンドでインストールする

```
cd piculet
bundle install --path=vendor/bundle
```

### Groupfile

Groupfile_sample をコピーする

```
cp Groupfile_sample Groupfile
```

Groupfile内の `my_ip` および `vpc_local_cidr` を適宜修正する

## Deploy

以下はBundlerでインストールした場合のコマンド

```
bundle exec piculet -a -n rdb_office,radius --dry-run
bundle exec piculet -a -n rdb_office,radius
```