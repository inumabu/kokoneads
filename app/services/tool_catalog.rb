module ToolCatalog
  TOOLS = [
    { slug: "json", name: "JSON 整形", description: "読みにくいJSONを、きれいに整形・検証", category: "開発", icon: "{ }", accent: "mint", meta: "整形 / 検証" },
    { slug: "text", name: "文字数カウント", description: "文字数・行数・バイト数をリアルタイム集計", category: "文章", icon: "Aa", accent: "blue", meta: "リアルタイム" },
    { slug: "url", name: "URLエンコード", description: "URLのエンコードとデコードをすばやく変換", category: "開発", icon: "↗", accent: "orange", meta: "Encode / Decode" },
    { slug: "base64", name: "Base64変換", description: "文字列をBase64へ。戻すときもワンクリック", category: "開発", icon: "64", accent: "purple", meta: "Encode / Decode" },
    { slug: "color", name: "カラー変換", description: "HEX・RGB・HSLを相互変換して色を管理", category: "デザイン", icon: "◉", accent: "pink", meta: "HEX / RGB / HSL" },
    { slug: "markdown", name: "Markdownプレビュー", description: "Markdownを書きながら、仕上がりを確認", category: "文章", icon: "M↓", accent: "teal", meta: "Live preview" },
    { slug: "timestamp", name: "Unixタイムスタンプ", description: "日時とUnix時刻を相互変換。現在時刻も取得", category: "開発", icon: "◷", accent: "indigo", meta: "Date / Epoch" },
    { slug: "uuid", name: "UUID生成", description: "安全なUUIDを必要な数だけワンクリック生成", category: "開発", icon: "#", accent: "green", meta: "v4 / Bulk" },
    { slug: "hash", name: "ハッシュ生成", description: "SHA-256 / SHA-1 / MD5をブラウザで計算", category: "開発", icon: "#̸", accent: "red", meta: "SHA / MD5" },
    { slug: "regex", name: "正規表現テスター", description: "パターンとテキストを入力してマッチを確認", category: "開発", icon: ".*", accent: "yellow", meta: "Match / Groups" },
    { slug: "diff", name: "テキスト差分", description: "2つの文章を比較して変更箇所を見つける", category: "文章", icon: "±", accent: "cyan", meta: "Compare" },
    { slug: "html", name: "HTMLエスケープ", description: "HTML特殊文字を安全にエスケープ・復元", category: "開発", icon: "</>", accent: "violet", meta: "Escape / Unescape" }
  ].freeze

  def self.all
    TOOLS
  end

  def self.find(slug)
    TOOLS.find { |tool| tool[:slug] == slug.to_s }
  end
end
