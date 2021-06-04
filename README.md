# モノレポサンプル

Code シリーズを使い、モノレポ戦略の場合にでディレクトリ毎にビルドするサンプルです。

以下のような実装になっています。

- 1 つの CodeCommit リポジトリに 2 つのアプリがある
- アプリ毎に 2 つ CodePipeline のパイプラインを作成してある
- リポジトリにコミットがあると 2 つのパイプラインが同時動き出す
- それぞれのパイプラインの中の CodeBuild プロジェクトでは各アプリ毎の buildspec.yml を指定してある
- 各 buildspec.yml で S3 に置いてある前回の git tree hash と比較し、変更がなければビルドしない

## 前提条件

- Terraform がセットアップ済み
- AWS のクレデンシャルがセットアップ済み
- git-remote-codecommit または認証情報ヘルパーがセットアップ済み

## 手順

パイプライン等のリソースをデプロイする。

```shell
terraform init
terraform apply
```

マネジメントコンソールで Secrets Manager を開いて、Terraformが 作成した `monorepo-sample-dockerhub` というシークレットに値を設定する。

|キー|値|
|---|---|
|username|Docker Hub のユーザー名|
|password|Docker Hub のパスワード|

Terraform が作成した CodeCommit リポジトリに[サンプルアプリケーション](https://github.com/sotoiwa/monorepo-sample-apps)を Push する。

```shell
cd <このリポジトリの外の適当なディレクトリに移動>
git clone https://github.com/sotoiwa/monorepo-sample-apps.git
cd monorepo-sample
# git-remote-codecommit の場合
git remote add cc codecommit::ap-northeast-1://monorepo-sample-apps
# 認証情報ヘルパーの場合
# git remote add cc https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/monorepo-sample-apps
git push cc main
```

CodePipeline で初回のイメージビルドが成功することを確認する。

`app1/htlm/index.html` を変更して Push し、app1 のみがビルドされることを確認する。
