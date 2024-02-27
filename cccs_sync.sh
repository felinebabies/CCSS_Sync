#!/bin/bash

# 外部設定ファイルの読み込み
source ./sync_config.sh

# バックアップディレクトリの基本パスを定義
backup_base_dir="./backup"

# 最新のファイルが存在するディレクトリを確認
echo "比較中..."
newest_local_file=$(find "$local_dir" -type f -printf "%T+ %p\n" | sort -r | head -n 1)
newest_remote_file=$(ssh "$remote_user@$remote_host" "find \"$remote_dir\" -type f -printf \"%T+ %p\n\"" | sort -r | head -n 1)

if [[ $newest_local_file > $newest_remote_file ]]; then
  newest_dir="local"
else
  newest_dir="remote"
fi

echo "最新のファイルは${newest_dir}ディレクトリにあります。"

# バックアップの作成
backup_time=$(date +"%Y%m%d-%H%M%S")
local_backup_dir="${backup_base_dir}/local_backup_${backup_time}"
remote_backup_dir="${backup_base_dir}/remote_backup_${backup_time}"

echo "ローカルとリモートのバックアップを作成中..."
mkdir -p "$local_backup_dir"
cp -a "$local_dir/." "$local_backup_dir/"
mkdir -p "$remote_backup_dir"
rsync -avz --exclude='*_backup_*' "$remote_user@$remote_host:$remote_dir/" "$remote_backup_dir"

# ユーザーに同期の方向を尋ねる
echo "自動的に決定された同期方向は '${newest_dir}' です。"
read -p "この同期方向で進めますか、それとも手動で設定しますか？ (auto/manual): " sync_direction_answer
if [[ $sync_direction_answer == "manual" ]]; then
  read -p "どの方向に同期しますか？ (local-to-remote/remote-to-local): " manual_sync_direction
  if [[ $manual_sync_direction == "local-to-remote" ]]; then
    newest_dir="local"
  elif [[ $manual_sync_direction == "remote-to-local" ]]; then
    newest_dir="remote"
  else
    echo "無効な入力です。スクリプトを終了します。"
    exit 1
  fi
fi

# ユーザーに同期の確認を求める
read -p "ディレクトリを同期しますか？ (yes/no): " answer
if [[ $answer == "yes" ]]; then
  if [[ $newest_dir == "local" ]]; then
    echo "ローカルからリモートへ同期中..."
    rsync -avz "$local_dir/" "$remote_user@$remote_host:$remote_dir"
  else
    echo "リモートからローカルへ同期中..."
    rsync -avz "$remote_user@$remote_host:$remote_dir/" "$local_dir"
  fi
  echo "同期完了しました。"
else
  echo "同期がキャンセルされました。"
fi
