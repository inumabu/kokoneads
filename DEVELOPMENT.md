# 🛠️ 開発ガイド

## 🧭 開発の基本

- 小さく変更し、変更理由と検証結果を同じ Pull Request に記録します。
- ユーザー向け表示は日本語を基本とし、状態や重要な操作には意味のある絵文字を添えます。
- 秘密情報、アクセストークン、実運用データをリポジトリへ追加しません。
- 既存の責務分離とテスト可能性を壊さないことを優先します。

## ▶️ ローカル検証

README に記載された標準検証コマンドを、変更前後で実行してください。依存関係を更新した場合は lockfile の差分もレビューします。

## 🌿 ブランチ

```text
feat/<短い説明>
fix/<短い説明>
docs/<短い説明>
```

## 📝 コミット

```text
feat: add lesson or command behavior
fix: handle invalid input safely
docs: clarify local setup
chore: update CI dependencies
```
