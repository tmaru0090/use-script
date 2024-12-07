#!/bin/bash

# 引数1: 対象のディレクトリ
# 引数2以降: サブディレクトリを再帰的に処理するオプション（任意）

# 引数1のディレクトリが存在するか確認
if [ ! -d "$1" ]; then
    echo "指定されたディレクトリ \"$1\" は存在しません。"
    exit 1
fi

# touchコマンドが利用できるか確認
if command -v touch &> /dev/null; then
    TOUCH_AVAILABLE=true
else
    TOUCH_AVAILABLE=false
fi

# touchコマンドを使うか代替処理をするかのフラグに基づいて処理を実行
if [ "$TOUCH_AVAILABLE" = true ]; then
    # touchコマンドが使える場合
    echo "$1"
    touch "$1/.gitkeep"
else
    # touchコマンドが使えない場合（代替方法）
    echo "$1"
    echo "" > "$1/.gitkeep"
fi

if [ "$2" == "/recursive" ]; then
    # 再帰的にサブディレクトリを検索して.gitkeepを作成
    find "$1" -type d | while read -r dir; do
        if [ -d "$dir" ]; then
            echo "Processing directory: $dir"
            if [ "$TOUCH_AVAILABLE" = true ]; then
                # touchコマンドが使える場合
                touch "$dir/.gitkeep"
            else
                # touchコマンドが使えない場合（代替方法）
                echo "" > "$dir/.gitkeep"
            fi
        fi
    done
fi

echo "処理が完了しました。"
