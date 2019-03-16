# README

LINEのメッセージに反応して、Googleフォトのアルバムから画像をランダムに選択し返信するボットです。
特定のユーザに定期的に画像をプッシュする機能もあります。
Heroku等にデプロイして利用できます。

## 利用方法

### Google Photos APIsの準備

APIを有効化し、トークン類を取得する。

参考：[Get started with REST](https://developers.google.com/photos/library/guides/get-started)、[Google Photos APIsでアルバム作成と写真のアップロード](https://qiita.com/zaki-lknr/items/97c363c12ede4c1f25d2)

- [API](https://developers.google.com/photos/library/guides/get-started)を有効化

- [API Console](https://console.developers.google.com/apis/library)からCLIENT IDとCLIENT SECRETを作成

- OAuth用の認証コードを取得

ブラウザで下記にアクセスし許可すると、認証コードが表示される。

```
https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=$GOOGLE_CLIENT_ID&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/photoslibrary&access_type=offline
```

- ACCESS TOKENとREFRESH TOKENを取得

```sh
$ curl -s --data "code=$AUTHORIZATION_CODE" --data "client_id=$GOOGLE_CLIENT_ID" --data "client_secret=$GOOGLE_CLIENT_SECRET" --data "redirect_uri=urn:ietf:wg:oauth:2.0:oob" --data "grant_type=authorization_code" --data "access_type=offline" https://www.googleapis.com/oauth2/v4/token

{
 "access_token": "GOOGLE_ACCESS_TOKEN",
 "token_type": "Bearer",
 "expires_in": 3600,
 "refresh_token": "GOOGLE_REFRESH_TOKEN"
}
```

- 画像を取得したいアルバムのIDを取得

```sh
$ curl -H 'Content-type: application/octet-stream' -H 'Authorization: Bearer $GOOGLE_ACCESS_TOKEN' https://photoslibrary.googleapis.com/v1/albums

{
  "albums": [
    {
      "id": "ALBUM_ID",
      "title": "XXXXXXXXXX",
      "productUrl": "https://photos.google.com/lr/album/XXXXXXXXXX",
      "mediaItemsCount": "XXX",
      "coverPhotoBaseUrl": "https://lh3.googleusercontent.com/lr/XXXXXXXXXX",
      "coverPhotoMediaItemId": "XXXXXXXXXX"
    }
  ],
  "nextPageToken": "XXXXXXXXXX"
}
```

アクセストークンが期限切れの場合には、リフレッシュトークンを利用して再取得する。

```sh
$ curl --data "refresh_token=$GOOGLE_REFRESH_TOKEN" --data "client_id=$GOOGLE_CLIENT_ID" --data "client_secret=$GOOGLE_CLIENT_SECRET" --data "grant_type=refresh_token" https://www.googleapis.com/oauth2/v4/token
```

### LINEボットの準備

参考：[Messaging APIを利用するには](https://developers.line.biz/ja/docs/messaging-api/getting-started/)

- [LINE Developers](https://developers.line.biz/ja/)でボットを作成し、チャンネルシークレットとアクセストークンを取得

### Herokuにデプロイ

- リポジトリをクローンし、```db/seeds.rb```を編集

```rb
# ここで指定したキーワードがメッセージに含まれていればボットが返信する
Keyword.create(name: "キーワード1")
Keyword.create(name: "キーワード2")

# 画像と一緒に返信するテキストを指定する
# 複数指定するとランダムに選ばれる
TextMessage.create(content: "テキストメッセージ1")
TextMessage.create(content: "テキストメッセージ2")
```

- Herokuにpush

```sh
$ heroku create
$ git push heroku master
```

- 環境変数を設定

```sh
$ heroku config:set LINE_CHANNEL_SECRET=XXXXXXXX
$ heroku config:set LINE_CHANNEL_TOKEN=XXXXXXXX
$ heroku config:set GOOGLE_CLIENT_ID=XXXXXXXX
$ heroku config:set GOOGLE_CLIENT_SECRET=XXXXXXXX
$ heroku config:set GOOGLE_REFRESH_TOKEN=XXXXXXXX
$ heroku config:set ALBUM_ID=XXXXXXXX
```

- DBを準備

```sh
$ heroku run rake db:migrate
$ heroku run rake db:seed
# アルバムの画像一覧を取得
$ heroku run rake db_maintenance:refresh_image_message
```

- アルバム情報更新用のタスクを設定

[Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler)を利用して、アルバムに追加／削除された画像をDBに反映するタスクを設定する。

```sh
$ heroku addons:create scheduler:standard
$ heroku addons:open scheduler
```

Dashboardが開かれるので、下記のタスクを深夜に実行するように登録する（時間がUTCであることに注意）。

```sh
rake db_maintenance:refresh_image_message
```

- LINE DevelopersでWebhook URLを設定

作成したHerokuアプリのエンドポイント（``your-app-name.herokuapp.com/callback``）をWebhook URLに設定する。設定してから有効になるまでは少し時間がかかる。

参考：[ボットを作成する](https://developers.line.biz/ja/docs/messaging-api/building-bot/)


以上でボットの設定は完了。ボットを友達に追加し、キーワードを含んだメッセージを送信するとアルバムの画像が返信される。

### プッシュ機能の設定

下記の設定をすれば、特定のユーザに定期的に画像をプッシュすることもできる。現時点の実装では1ユーザのみ設定可能。

- Herokuのログから、プッシュしたいユーザのIDを調べる

ボットにメッセージを送ると、Herokuのログにリクエストの内容が表示される。その中にユーザIDが含まれている。リクエストの見方は[Messaging APIリファレンス](https://developers.line.biz/ja/reference/messaging-api/)を参照。

- 環境変数にユーザIDを設定

```sh
$ heroku config:set USER_ID_TO_PUSH=XXXXXXXX
```

- Heroku Schedulerに、メッセージをプッシュする下記のタスクを追加

```sh
rake linebot:push_message
```