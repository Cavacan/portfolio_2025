■サービス概要
・定期購入品や購入予定品を登録し、予定が近づくとメール等で通知したうえで次回の通知を自動設定してくれる。
・買い物メモを家族で共有してリストの更新・追加ができ、PDFを出力したり、メール送信・LINE通知が出来る。
・過去の履歴を集計して頻度や周期を確認でき、価格を入力しておくと使用金額を把握できる。


■ このサービスへの思い・作りたい理由
・定期的に買う消耗品の買い忘れや二度買いをよくしてしまうので通知機能が欲しかったため。
　カレンダーアプリでは設定項目が多くて手間もがかり、
　購入タイミングによって周期設定を都度変えなくてはいけなかったため。
・完全な在庫管理ではなく、手間なく買い忘れや在庫過多を防げるサービスです。
【エピソード】
　◇漫画の新刊の発売時期を忘れ、発売日を過ぎてから気が付いた。
　◇洗剤がないと思って買って帰ったところ、既に購入して棚の中に入っていた。


■ ユーザー層について
対象：一人暮らし、ファミリー
　一人暮らし：家事の時間を確保が難しく、在庫管理が甘くなりやすいため。
　ファミリー：消費サイクルが早くなりがちで種類も多いため在庫管理の負担が大きいため。


■サービスの利用イメージ
・購入タイミングを通知してくれるので在庫を覚える必要がなくなり、紙のメモを書いて置き忘れたり、メモ帳アプリを開いて書き足したり消したりする作業が不要になる。
・通知が来たタイミングで簡単にスヌーズができ、次回の予定もそれに合わせて自動で変更される。
・家族で買い物リストを共有して、作成・更新ができる。
・履歴から購入頻度を確認し、買い過ぎを把握できる。

■ ユーザーの獲得について
・使用方法のショート動画を作り、SNSなどにアップする。
・買い物メモを家族で共有する際、メモにアカウント新規作成リンクを付ける。
・アカウント画面に他メールアドレス宛ての紹介送信機能を付ける。
・（有料ネット広告を活用する。）


■ サービスの差別化ポイント・推しポイント
・Googleカレンダーの予定機能。
　差別化ポイント：リピート購入に絞ることで設定項目をシンプルにし、予定変更の発生を前提として周期の提案を行うことで利便性を高める。
・リマインダーアプリ
　差別化ポイント：履歴から利用頻度を確認し、購入周期を見直すきっかけにできる。
　　　　　　　　　買い物リストを複数人で共有し、誰が購入しても反映できる。
　　　　　　　　　本通知とは別に、予定が近いものだけのリストを一定周期で通知して予定に変更がないかチェックできる。


■ 機能候補
**【MVPリリースまで】（使用技術など）**
- ユーザー認証、通知一覧及び通知予定のCRUD機能
- メール通知（ActiveMailer）
- 通知送信判定（cron）
- 通知メールに通知予定変更（スヌーズ機能）用のリンクを添付する機能 （トークンを使用し認証）

**【本リリースまで】（使用技術など）**
- 通知テンプレートとなる日用品ジャンルの登録
- 一定期間（月）に含まれる通知予定だけをまとめたリストを作成し、事前に通知。
　事前通知のリストには”予定外購入済み”の設定リンクを設け、次回の通知が通常の周期で設定されるようにする。
- 買い物メモの生成、PDF出力（prawn）、メール送信
- 買い物メモを共有- 更新
- 購入履歴を集計して表示
- LINE、DiscordなどSNS通知（ LINE Notify >> LINE Messaging API ）
- Googleカレンダーとの連携（ Google Calendar API ）
- 設定変更をアイコンや色で分かりやすくし、できるだけシンプルなインターフェイスにする。（ JavaScript、CSS ）
- 通知メールにワンタイムの通知変更用リンクを挿入、ログインなしで予定変更を可能にする。
- 予定の事前通知リストの周期をユーザーで変更できる。
- 予定変更時、過去の利用状況から通知周期の提案を行う。
- メールが埋もれてしまわないようにする興味付けとして豆知識をランダム添付（データベース）
- 添付する豆知識をジャンルの傾向や利用頻度に合わせてパーソナライズし配信する。
- 買い物メモをユーザーがカスタマイズ、通知予定のないものも書き加えられるようにする。
- オプションで、購入済みのチェックがされない限り再通知を繰り返す。
- 利用頻度を集計しグラフなどで視覚化する。（ JavaScript ）
- サーバー負荷を考え、通知送信判定の処理タイミングの分散、メールの段階送信機能を作成する。

■ 機能の実装方針予定
一般的なCRUD以外の実装予定の機能についてそれぞれどのようなイメージ(使用するAPIや)で実装する予定なのか現状考えているもので良いので教えて下さい。
・通知予定時刻かを判定する関数をcronを使って定期実行し、ActionMailerを使ってメールを送信。
・通知はメールの他、LINEやGoogleカレンダーなどのAPIを使って連携して通知を送れるようにする。
・メールに添付する設定用リンクは、SecureRandomモジュールで生成したユーザーに紐付くトークンを元に作成する。このトークンは定期的に更新する。
・JavaScriptを使って、選択すると色が変わったり入力欄の変更が他と連動するなどユーザーの使い勝手を重視する。

**【拡張性 -追加サービス案・追加機能案-】**
- **アイテムの匿名レビュー投稿機能**
  レビュー、コメント、いいね
  ※匿名につき、信憑性を判断できるようにレビュー投稿者の使用歴（継続期間・累計使用数）も表示する。
- **ランキング表示機能**
  アイテムのジャンル別に利用ユーザー数、利用頻度のランキングを表示
- **サジェスト機能**
  ユーザーの利用アイテムと同種のオススメ（人気アイテム）を提示
- **BtoC広告の挿入機能**
  同種のアイテムを使用しているユーザー向けにメール配信やアプリ画面に表示して訴求
- **店舗別の買い物メモ作成**
  アイテムの買い出し店舗を設定（複数可）し店舗別の買い物メモを作成。
  位置情報を利用して当該店舗及びグループ店でアプリを開くと買い物メモがトップに表示される。
- **店舗の特売情報の通知機能**
  Webスクレイピングで定期巡回して情報が更新されていた場合、店舗を設定しているユーザーに通知
  ※サイトの利用ポリシー（スクレイピング禁止）とサイトリニューアルによる追跡エラーに注意する。
