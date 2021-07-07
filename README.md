# insta_clone

## docker-composeを用いた環境構築

### コンテナイメージをビルド

```bash
$ docker-compose build
```

### コンテナをバックグラウンドで起動

```bash
$ docker-compose up -d
```

### コンテナ内に入る(bashを起動する)

```bash
$ docker-compose exec my-app bash
```

### Railsアプリケーションを作成する

`-J`: javascript関連のセットアップをスキップ

`-T`: テスト関連のセットアップをスキップ

`--skip-turbolinks`: turbolinksのセットアップをスキップ

`--skip-coffee`: CoffeeScriptのセットアップをスキップ 

```bash
$ rails new . -d mysql -s --skip-turbolinks --skip-coffee
```

`config/database.ymlを開きhostを変更する`

```yaml
-  host: localhost
+  host: my-database
```

### アプリケーションを起動する

```bash
$ rails db:create
$ rails db:migrate
$ rails s --binding=0.0.0.0
$ # 停止する場合はcmd + c
```

Webブラウザで http://localhost:3000 へアクセス