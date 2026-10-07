# kokoneads アーキテクチャ

## 1. システム概要

kokoneadsは、Railsのサーバーレンダリングを基盤にした小規模なツールサイトです。画面はERBで生成し、個々のツール処理は`public/kokoneads.js`が担当します。

```text
Browser
  ├─ GET /                  ──> ToolsController#index ──> ToolCatalog
  ├─ GET /tools/:slug       ──> ToolsController#show  ──> ToolCatalog
  ├─ GET/POST /login        ──> SessionsController
  ├─ GET/POST /signup       ──> RegistrationsController
  ├─ GET /account           ──> AccountController ──> SQLite
  └─ POST /tools/:slug/history ──> ToolHistoriesController ──> SQLite

Browser JavaScript
  ├─ JSON / text / URL / Base64 / color / Markdown
  ├─ timestamp / UUID / hash / regex / diff / HTML
  └─ ログイン中のみ履歴APIへ入力プレビューを送信
```

## 2. レイヤー構成

### 2.1 ルーティング

`config/routes.rb`では、トップ、ツール詳細、認証、アカウント、お気に入り、履歴のルートを定義しています。リソースフルな複雑さを避け、slugベースの小さなエンドポイントにしています。

### 2.2 コントローラー

- `ToolsController`: ツール一覧と詳細画面
- `SessionsController`: ログイン、ログアウト
- `RegistrationsController`: アカウント作成
- `AccountController`: 認証済みワークスペース
- `SavedToolsController`: お気に入りの追加・解除
- `ToolHistoriesController`: 利用履歴の保存
- `ApplicationController`: 現在のユーザー、認証要求、共通ヘルパー

認証が必要なコントローラーでは`require_authentication`を`before_action`として使用します。

### 2.3 ドメインデータ

ツールの定義はDBではなく`ToolCatalog`に集約しています。ツールの追加にDBマイグレーションを必要としないため、静的なユーティリティカタログとして扱いやすい構成です。

```ruby
ToolCatalog.find("json")
ToolCatalog.all
```

ツールを増やすときは、次の3箇所を同期します。

1. `app/services/tool_catalog.rb`に定義を追加
2. `app/views/tools/show.html.erb`にslugごとのUIを追加
3. `public/kokoneads.js`にslugごとの処理を追加

必要に応じて、`public/manus-routes.json`とREADMEのツール表も更新します。

### 2.4 ビュー

- `app/views/tools/_shell.html.erb`: サイドバー、ヘッダー、検索、ユーザー導線
- `app/views/tools/index.html.erb`: ツール一覧
- `app/views/tools/show.html.erb`: slugごとのツールワークスペース
- `app/views/account/show.html.erb`: お気に入りと履歴
- `app/views/sessions/new.html.erb`: ログイン
- `app/views/registrations/new.html.erb`: アカウント作成
- `app/views/shared/_flash.html.erb`: 通知表示

## 3. 認証フロー

### 3.1 アカウント作成

1. `GET /signup`でフォームを表示
2. `POST /signup`でstrong parametersを通過
3. `User`がメール形式、表示名、パスワードを検証
4. 保存成功時に`reset_session`
5. `session[:user_id]`へユーザーIDを保存
6. トップページへリダイレクト

### 3.2 ログイン

1. `GET /login`でフォームを表示
2. `POST /login`でメールアドレスを正規化
3. `User#authenticate`でbcryptハッシュと照合
4. 成功時にセッションをリセット
5. `session[:user_id]`を設定
6. 保存済みの`session[:return_to]`、なければトップへ移動

### 3.3 ログアウト

`DELETE /logout`でセッション全体をリセットし、トップページへ戻します。

## 4. 利用履歴フロー

ツール画面のJavaScriptは、ログイン中に実行した操作の一部で`POST /tools/:slug/history`を呼び出します。サーバー側では次を行います。

1. `require_authentication`で認証確認
2. `ToolCatalog.find`でslugを検証
3. `input_preview`を文字列化して500文字に切り詰める
4. `current_user.tool_histories`へ保存
5. JSONで作成済みIDを返す

履歴保存に失敗してもツール処理自体は止めないよう、クライアント側では`fetch`の失敗を握りつぶします。これは未ログイン利用者の通常操作を妨げないためです。

## 5. データ整合性

- `users.email`はDBの一意インデックスとモデル検証の両方で一意化
- `saved_tools(user_id, slug)`は複合一意インデックスで重複防止
- `saved_tools`と`tool_histories`はusersへの外部キーを持つ
- User削除時はお気に入りと履歴を`dependent: :destroy`で削除
- ツールslugは`ToolCatalog`の定義を正とする

## 6. クライアントサイド処理

`public/kokoneads.js`は画面に存在する`data-*`属性を検出して、現在のslugに応じた処理を初期化します。詳細な処理対象は以下です。

| slug | 主なDOM属性 | 主なAPI |
|---|---|---|
| `json` | `data-json-input` | `JSON.parse` / `JSON.stringify` |
| `text` | `data-text-input` | `TextEncoder` |
| `url` | `data-url-input` | `encodeURIComponent` |
| `base64` | `data-base-input` | `btoa` / `atob` |
| `color` | `data-color-picker` | HEX/RGB/HSL計算 |
| `markdown` | `data-markdown-input` | 簡易HTML変換 |
| `timestamp` | `data-timestamp-date` | `Date` |
| `uuid` | `data-uuid-count` | `crypto.randomUUID` |
| `hash` | `data-hash-input` | `crypto.subtle.digest` |
| `regex` | `data-regex-pattern` | `RegExp` |
| `diff` | `data-diff-left` | 行単位比較 |
| `html` | `data-html-input` | DOM textareaによる復元 |

新しい処理を追加する場合は、DOM属性名を既存命名規則に合わせ、HTMLエスケープが必要な箇所には`escapeHtml`を使用します。

## 7. セキュリティ境界

### サーバー側

- Rails CSRF保護
- bcryptによるパスワードハッシュ
- セッションリセット
- strong parameters
- 認証必須の更新エンドポイント
- ERB自動エスケープ
- CSPメタタグ

### クライアント側

- ツール入力は通常外部へ送信しない
- Markdownプレビューは限定的な変換のみ
- 差分・正規表現結果はHTMLエスケープして表示
- HTML復元はtextareaを経由して文字列化

## 8. 拡張方針

### ツールのDB管理が必要になった場合

現状は静的カタログが適していますが、管理画面、公開状態、ツールごとの権限、翻訳、利用統計が必要になった場合は`tools`テーブルへの移行を検討します。その場合でも、slugはURLと履歴の互換性のために維持します。

### 履歴が増えた場合

- ユーザーごとの最大保存件数を設定
- 古い履歴の自動削除をJob化
- `user_id, created_at`インデックスを活用したページング
- 入力プレビューの保存可否をユーザー設定にする

### 大規模化した場合

- SQLiteからPostgreSQLへ移行
- Redis等のキャッシュ導入
- アセットのfingerprintとCDN配信
- 監視、構造化ログ、エラートラッキング導入
- APIレスポンスのレート制限

## 9. 変更時のチェックリスト

- [ ] ToolCatalogのslug、名前、カテゴリ、説明を追加・更新
- [ ] ツール詳細ERBのUIを追加
- [ ] JavaScriptの初期化処理を追加
- [ ] `public/manus-routes.json`を更新
- [ ] READMEのツール一覧を更新
- [ ] `node --check public/kokoneads.js`
- [ ] `bundle exec rails zeitwerk:check`
- [ ] `git diff --check`
- [ ] 主要URLをcurlまたはブラウザで確認
- [ ] 認証が絡む変更ではCSRF、未ログイン、重複保存を確認
