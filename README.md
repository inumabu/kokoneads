# 🧰 kokoneads

> 毎日の小さな作業を、ひとつの場所で片づけるRails製ツールサイト。

kokoneadsは、開発・文章作成・デザイン作業で頻繁に使う変換・検証ツールを、ログイン不要ですぐ使えるようにまとめたWebアプリケーションです。処理の中心はブラウザ内で行うため、入力データを外部サービスへ送信せずに利用できます。

## 目次

- [主な特徴](#主な特徴)
- [ツール一覧](#ツール一覧)
- [使い方](#使い方)
- [アカウント機能](#アカウント機能)
- [プライバシーとデータ保存](#プライバシーとデータ保存)
- [技術構成](#技術構成)
- [セットアップ](#セットアップ)
- [開発コマンド](#開発コマンド)
- [URLとルーティング](#urlとルーティング)
- [データベース](#データベース)
- [セキュリティ](#セキュリティ)
- [運用・デプロイ時の注意](#運用デプロイ時の注意)
- [トラブルシューティング](#トラブルシューティング)
- [ライセンス](#ライセンス)

## 主な特徴

- 12種類のブラウザ内ユーティリティ
- ログインなしで全ツールを利用可能
- `⌘ K` / `Ctrl K` でツール検索にフォーカス
- レスポンシブ対応のダッシュボードUI
- アカウント作成、ログイン、ログアウト
- お気に入りツールの保存
- 最近使ったツールの履歴表示
- Rails標準のCSRF保護とbcryptパスワードハッシュ化
- SQLiteによるシンプルなデータ管理

## ツール一覧

| slug | ツール | カテゴリ | 機能 |
|---|---|---|---|
| `json` | JSON 整形 | 開発 | JSONの整形・構文検証 |
| `text` | 文字数カウント | 文章 | 文字数、空白なし文字数、行数、UTF-8バイト数 |
| `url` | URLエンコード | 開発 | URLエンコード・デコード |
| `base64` | Base64変換 | 開発 | UTF-8文字列のBase64エンコード・デコード |
| `color` | カラー変換 | デザイン | HEX、RGB、HSLの表示と相互確認 |
| `markdown` | Markdownプレビュー | 文章 | 見出し、太字、コードなどの簡易ライブプレビュー |
| `timestamp` | Unixタイムスタンプ | 開発 | 日時とUnix時刻の相互変換、現在時刻の表示 |
| `uuid` | UUID生成 | 開発 | UUID v4を1〜20個生成 |
| `hash` | ハッシュ生成 | 開発 | SHA-256、SHA-1のブラウザ内計算。MD5は非推奨案内のみ |
| `regex` | 正規表現テスター | 開発 | JavaScript正規表現のマッチ確認 |
| `diff` | テキスト差分 | 文章 | 2つのテキストを行単位で比較 |
| `html` | HTMLエスケープ | 開発 | HTML特殊文字のエスケープ・復元 |

### ツール利用時の注意

- JSON、正規表現、Markdownなどの解析はJavaScriptの仕様に準拠します。
- Markdownプレビューは外部Markdownライブラリではなく、画面表示に必要な範囲の簡易変換です。
- ハッシュ計算はWeb Crypto APIを利用します。対応ブラウザで利用してください。
- MD5は安全なハッシュ用途には適していないため、画面上では警告を表示して計算しません。
- 変換結果は基本的に画面上で生成され、サーバーには保存されません。

## 使い方

1. トップページでツールカードを選択します。
2. 入力欄へテキストを入力します。
3. ツールごとの実行ボタンを押すか、リアルタイム結果を確認します。
4. 必要に応じて「結果をコピー」または「クリア」を利用します。
5. `⌘ K`（macOS）または `Ctrl K`（Windows / Linux）で検索欄へ移動できます。

トップページの検索欄は、ツール名とカテゴリを対象にクライアントサイドで絞り込みます。

## アカウント機能

### アカウント作成

`/signup` から表示名、メールアドレス、8文字以上を推奨するパスワードを登録します。登録成功後はログイン済みの状態でトップページへ移動します。

### ログイン

`/login` からメールアドレスとパスワードを入力します。メールアドレスは前後の空白を除去し、小文字化して扱います。

### お気に入り

ログイン中にツール詳細画面の「お気に入り」ボタンを押すと、ツールがマイワークスペースに保存されます。同じツールを複数回保存しても重複しません。

### マイワークスペース

`/account` で以下を確認できます。

- お気に入りに登録したツール
- 最近使ったツール（新しいものから最大8件）
- 登録メールアドレス
- ログアウト操作

未ログインで `/account` にアクセスした場合は、ログイン画面へリダイレクトされます。ログイン前にアクセスしようとしたURLはセッションに保持され、ログイン後に戻れる設計です。

## プライバシーとデータ保存

> 入力データそのものを通常のツール処理のためにサーバーへ送信することはありません。

ただし、ログイン中にツールを操作した場合は、最近使ったツールを表示する目的で次の履歴を保存します。

- ツールのslug
- 入力内容の先頭500文字以内のプレビュー
- 作成日時・更新日時

履歴保存はログインユーザーに限定されます。未ログインユーザーの入力は履歴として保存されません。パスワードは平文で保存せず、bcryptの`password_digest`として保存します。

## 技術構成

| 項目 | 採用技術 |
|---|---|
| アプリケーション | Ruby on Rails 8.1 |
| Ruby | Ruby 3.2以上を想定 |
| データベース | SQLite3 |
| Webサーバー | Puma |
| アセット | Propshaft |
| フロントエンド | ERB + Vanilla JavaScript + CSS |
| 認証 | `has_secure_password` + bcrypt |
| セッション | Rails標準セッション |
| セキュリティ診断 | Brakeman、bundler-audit（開発依存） |

## セットアップ

### 前提条件

- Ruby 3.2以上
- Bundler
- SQLite3開発ライブラリ
- Node.js（JavaScript構文確認を行う場合）
- Git

### 初回セットアップ

```bash
git clone https://github.com/inumabu/kokoneads.git
cd kokoneads
bundle install
bin/rails db:prepare
```

`db:prepare` は必要に応じてデータベース作成とマイグレーションを実行します。

### 開発サーバーの起動

```bash
bin/rails server -b 0.0.0.0 -p 3000
```

ブラウザで <http://localhost:3000> を開きます。

### 既存DBを作り直す場合

ローカル開発データを破棄して作り直す場合のみ実行してください。

```bash
bin/rails db:drop db:create db:migrate
```

## 開発コマンド

```bash
# サーバー起動
bin/rails server

# マイグレーション
bin/rails db:migrate

# マイグレーション状態確認
bin/rails db:migrate:status

# Railsのロードチェック
bin/rails zeitwerk:check

# ルーティング確認
bin/rails routes

# Ruby構文確認
find app config db -name '*.rb' -print0 | xargs -0 -n1 ruby -c

# JavaScript構文確認
node --check public/kokoneads.js

# 差分の空白エラー確認
git diff --check

# Brakeman（必要に応じて実行）
bundle exec brakeman

# 依存関係の脆弱性確認
bundle exec bundler-audit check --update
```

## URLとルーティング

| Method | Path | 用途 | 認証 |
|---|---|---|---|
| GET | `/` | ツール一覧 | 不要 |
| GET | `/tools/:slug` | ツール詳細 | 不要 |
| GET | `/login` | ログイン画面 | 不要 |
| POST | `/login` | ログイン処理 | 不要 |
| DELETE | `/logout` | ログアウト | 不要 |
| GET | `/signup` | アカウント作成画面 | 不要 |
| POST | `/signup` | アカウント作成処理 | 不要 |
| GET | `/account` | マイワークスペース | 必須 |
| POST | `/tools/:slug/save` | お気に入り追加 | 必須 |
| DELETE | `/tools/:slug/save` | お気に入り解除 | 必須 |
| POST | `/tools/:slug/history` | 利用履歴保存 | 必須 |
| GET | `/up` | Railsヘルスチェック | 不要 |

ツールslugが存在しない場合、通常の画面アクセスではトップページへ戻し、履歴エンドポイントではJSONの404を返します。

## データベース

### users

| カラム | 型 | 制約 |
|---|---|---|
| `email` | string | 必須・一意・メール形式 |
| `display_name` | string | 必須・最大40文字 |
| `password_digest` | string | 必須・bcryptハッシュ |
| `created_at` / `updated_at` | datetime | Rails標準 |

### saved_tools

| カラム | 型 | 制約 |
|---|---|---|
| `user_id` | integer | 必須・users外部キー |
| `slug` | string | 必須。ユーザー単位で一意 |
| `created_at` / `updated_at` | datetime | Rails標準 |

### tool_histories

| カラム | 型 | 制約 |
|---|---|---|
| `user_id` | integer | 必須・users外部キー |
| `slug` | string | 必須 |
| `input_preview` | string | 任意・最大500文字 |
| `created_at` / `updated_at` | datetime | Rails標準 |

関連レコードはユーザー削除時に`dependent: :destroy`で削除されます。

## セキュリティ

- パスワードは`has_secure_password`とbcryptでハッシュ化します。
- ログイン成功時とアカウント作成時にセッションをリセットし、セッション固定攻撃を抑制します。
- 状態を変更するフォームはRailsのCSRF保護を利用します。
- アカウント、保存、履歴エンドポイントには認証チェックを設けています。
- 画面に表示するユーザー入力は原則ERBの自動エスケープを通します。
- HTMLエスケープツールのプレビューは、入力をHTMLとして解釈せず文字列として扱います。
- CSPメタタグをレイアウトへ設定しています。
- 本番環境では詳細な例外画面を表示せず、HTTPS、秘密情報管理、適切なCookie設定を必ず確認してください。

## 運用・デプロイ時の注意

- `config/master.key`や本番用秘密情報をリポジトリへ公開しないでください。
- `RAILS_ENV=production bin/rails db:prepare`を実行してからアプリケーションを起動します。
- 本番ではSQLiteのバックアップ、書き込み権限、同時接続数を確認してください。規模が大きくなる場合はPostgreSQL等への移行を検討します。
- `config/environments/development.rb`のManusプレビュー用ホスト許可は開発環境向けです。本番の許可ホストは実際のドメインだけに限定してください。
- 本番サーバーでは次のように、外部からアクセス可能なバインドを必要に応じて設定します。

```bash
RAILS_ENV=production bin/rails server -b 0.0.0.0 -p 3000
```

- リバースプロキシやPaaSを利用する場合は、HTTPS終端、ヘルスチェック、ログ出力、DBバックアップを別途設定してください。

## トラブルシューティング

### `Bundler could not find compatible versions`

RubyとBundlerのバージョンを確認してから、依存関係を再解決します。

```bash
ruby -v
bundle -v
bundle update
```

### `PendingMigrationError`

未適用のマイグレーションを実行します。

```bash
bin/rails db:migrate
```

### ツール画面のJavaScriptが動かない

対応ブラウザを確認し、ブラウザの開発者コンソールでエラーを確認します。JavaScriptファイル単体の構文は次で確認できます。

```bash
node --check public/kokoneads.js
```

### ログインできない

- メールアドレスの前後空白や大文字小文字を確認します。
- パスワードは正確に入力してください。
- 開発環境ではCookieが無効化されていないか確認します。
- セッションを消去してから再度ログインします。

## 設計資料

より詳細な構成、リクエストの流れ、拡張方針は[アーキテクチャドキュメント](docs/ARCHITECTURE.md)を参照してください。

## ライセンス

ライセンスを明示する場合は、プロジェクトの利用方針に合わせて`LICENSE`ファイルを追加してください。現時点では、このリポジトリに個別のライセンスファイルは含まれていません。


## 📚 開発管理文書

- [開発ガイド](DEVELOPMENT.md)
- [貢献ガイド](CONTRIBUTING.md)
- [テスト方針](TESTING.md)
- [セキュリティ](SECURITY.md)
- [アーキテクチャ](docs/ARCHITECTURE.md)
- [リリース手順](RELEASE.md)
- [ロードマップ](ROADMAP.md)
- [変更履歴](CHANGELOG.md)


## 🧪 一括検証

テスト・Lint・セキュリティ監査・Buildをまとめて実行します。

```sh
bin/verify
```
