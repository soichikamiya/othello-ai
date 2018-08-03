# オセロAIの対戦を行う手順
１．Githubのトップ画面の画面右上にある『Fork』ボタンを押下して自身のGithub上にコピーを作成します。<br>
　※トップ画面のURLは『https://github.com/toit/othello-ai』<br>
　※（アカウント名）/othello-ai　というブランチができます<br>
２．新規のAWSCloud9を立ち上げ、手順１でコピーしたリポジトリをcloneします<br>
　※立ち上げたCloud9上でgit clone (リポジトリ名)　を入力します<br>
３．cd othello_apps　コマンドにてGemfileが直下にあるフォルダにディレクトを移動します<br>
４．bundle install　コマンドを実行します<br>
５．rails s -b 0.0.0.0　コマンドを実行してサーバを立ち上げます<br>
６．手順２で新規作成したCloud9に関連するAWSのEC2を確認します。<br>
　※Go To Dashboard　→　サービスのEC2　→　実行中のインスタンス　→　該当インスタンスをクリック<br>
７．説明タブ欄の『IPv4 パブリック IP』に記載されているIPアドレス値を取得します<br>
８．同タブ欄の『セキュリティグループ』の値がリンクとなっているのでクリックします<br>
９．インバウンドタブ欄の編集ボタンをクリックして以下の設定を追加し保存します<br>
・タイプ：カスタムTCP<br>
・プロトコル：TCP<br>
・ポート範囲：8080<br>
・ソース：マイIP<br>
１０．オセロ対戦用の画面にて『APIのURL』に以下のURLを追加すればOKです<br>
http://（手順７で取得したIPアドレス）/othellos/reception<br>

# othello-ai
AIを作ってみるワークショップです。

## 対戦用URL
http://othello-ai.s3-website-ap-northeast-1.amazonaws.com/index.html

## 仕様
自作APIのエンドポイントを「APIのURL」欄に入れると
１手ごとに「盤面の状態」と「おける場所」がpostされます。
このリクエストに対して、
おける場所のなかから１つ決めて、そのindexを返すと
そこに打ってくれます。

## Thanks
https://github.com/kana/othello-js