@echo off
chcp 65001
REM git_keep_touch.bat

REM 引数1: 対象のディレクトリ
REM 引数2以降: サブディレクトリを再帰的に処理するオプション（任意）

REM 引数1のディレクトリが存在するか確認
if not exist "%~1" (
    echo 指定されたディレクトリ "%~1" は存在しません。
    exit /b 1
)

REM touchコマンドが利用できるか確認
where touch >nul 2>nul
set TOUCH_AVAILABLE=%errorlevel%

REM touchコマンドを使うか代替処理をするかのフラグに基づいて処理を実行
if %TOUCH_AVAILABLE% == 0 (
    REM touchコマンドが使える場合
    echo %~1
    touch "%~1\.gitkeep"
) else (
    REM touchコマンドが使えない場合（代替方法）
    echo %~1
    echo. > "%~1\.gitkeep"
)

if "%~2" == "/recursive" (
    REM 再帰的にサブディレクトリを検索して.gitkeepを作成
    for /r "%~1" %%d in (.) do (
        if exist "%%d\" (
            echo Processing directory: %%d
            if %TOUCH_AVAILABLE% == 0 (
                REM touchコマンドが使える場合
                touch "%%d\.gitkeep"
            ) else (
                REM touchコマンドが使えない場合（代替方法）
                echo. > "%%d\.gitkeep"
            )
        )
    )
)

echo 処理が完了しました。
