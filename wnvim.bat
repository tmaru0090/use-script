@echo off

set CUSTOM_ARG_MINIMUM=false
set REMAINING_ARGS=

:: 引数をループで確認
:loop
if "%~1"=="" goto endloop
:: ここで条件分岐を増やすことでカスタム引数を追加可能
if "%~1"=="--minimum" (
    set CUSTOM_ARG_MINIMUM=true
) else (
    :: 引数をREMAINING_ARGSに追加
    set REMAINING_ARGS=%REMAINING_ARGS% "%~1"
)
shift
goto loop
:endloop

:: 環境変数を設定
if "%CUSTOM_ARG_MINIMUM%"=="true" (
    set NVIM_PLUGIN_MINIMUM=1
)

:: Neovimを実行
nvim %REMAINING_ARGS%
