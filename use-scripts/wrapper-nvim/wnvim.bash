#!/bin/bash

CUSTOM_ARG_MINIMUM=false
REMAINING_ARGS=""

# 引数をループで確認
for arg in "$@"; do
    if [ "$arg" == "--minimum" ]; then
        CUSTOM_ARG_MINIMUM=true
    else
        # 引数をREMAINING_ARGSに追加
        REMAINING_ARGS="$REMAINING_ARGS \"$arg\""
    fi
done

# 環境変数を設定
if [ "$CUSTOM_ARG_MINIMUM" == true ]; then
    export NVIM_PLUGIN_MINIMUM=1
fi

# Neovimを実行
eval nvim $REMAINING_ARGS
