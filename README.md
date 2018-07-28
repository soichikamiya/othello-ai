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
