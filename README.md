# 2023年10月 UPSIDER 課題

https://github.com/upsidr/coding-test/blob/6f588e6205f2da4c41901cc1154c190eeaa8d4f3/web-api-language-agnostic/README.ja.md

## ファイル構成

* デザインドキュメント: [`DESIGN.md`](./DESIGN.md)
* サーバサイド: [Ruby on Rails](https://rubyonrails.org/)
  - [`config/routes.rb`](./config/routes.rb): ルーティング設定
  - `config/**/*.rb`: 設定コード群
  - `app/**/*.rb`: アプリケーションコード群
  - `db/**/*.rb`: データベース設定コード群
  - `test/**/*.rb`: テストコード群
* クライアントサイド: [Vite](https://vitejs.dev/guide/)
  - [`index.html`](./index.html): エントリーポイント
  - `client/**/*`: 読み込み用コード群

## 立ち上げ方

まず、以下をインストールしてください:

* [Ruby v3.2.2](https://www.ruby-lang.org/)
* [Node.js v20.7.0](https://nodejs.org/)
* [Bundler v2.4.10](https://bundler.io/)
* [pnpm v8.7.4](https://pnpm.io/)

次に、

```
bundle install
pnpm install
bin/rails db:migrate
```

を実行して、依存ライブラリをインストールし、データベースにセットアップを行います。

そして、お好みでダミーデータを挿入します:

```
echo 'load "./scripts/insert_dummy.rb"' | bin/rails console
```

次にサーバを起動します:

```
bin/foreman start --procfile Procfile.dev
```

それから http://localhost:5173/ をブラウザで開くと、サービス画面が開きます。

### テスト実行

```
bin/rails test
```

## ライセンス表記

```
Copyright 2023 Mizunashi Mana

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
