
# CCSS Sync Tool

このプロジェクトは、ローカルとリモートのディレクトリ間で最新のファイルを同期するためのツールを提供します。主にゲームのセーブデータなどをSteam DeckとPC間で同期するのに使用できます。

## 機能

- ローカルとリモートの最新ファイルを比較し、最新のファイルで同期を行います。
- ローカルとリモートの両方でバックアップを作成し、安全な同期を行います。
- ユーザーが同期の方向を手動で選択するオプションを提供します。

## 使い方

1. `sync_config.sh` ファイルにあなたの設定（`remote_host`, `remote_user`, `remote_dir`,`local_dir`）を定義します。
2. 実行権限をスクリプトに与えます： `chmod +x cccs_sync.sh`
3. スクリプトを実行します： `./cccs_sync.sh`

## 設定

`sync_config.sh` ファイルに以下の変数を設定してください。

```bash
#!/bin/bash

# 外部設定変数
remote_host="あなたのリモートホスト名"
remote_user="あなたのリモートユーザー名"
local_dir="ローカル側同期ディレクトリ"
remote_dir="リモート側同期ディレクトリ"
```

## ライセンス

MIT License
