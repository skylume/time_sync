@echo off
chcp 65001 > nul
title 时间同步工具打包脚本

echo ==============================================
echo          时间同步工具打包程序
echo ==============================================
echo.

:: 检查Python是否安装
where python > nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未找到Python环境，请先安装Python
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

:: 安装/升级PyInstaller（Win7 只支持 PyInstaller 5.x，勿用最新版6.x）
:: 先卸载旧版再装兼容版本，避免 --upgrade 拉到不支持 Win7 的新版
pip uninstall -y pyinstaller >nul 2>nul
pip install "pyinstaller==5.13.2" > nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 安装PyInstaller失败，请手动执行: pip install pyinstaller==5.13.2
    pause
    exit /b 1
)

:: 开始打包
echo 正在打包应用程序，请稍候...
echo.

pyinstaller ^
  --onefile ^
  --windowed ^
  --name="时间同步工具" ^
  --icon="clock.ico" ^
  --manifest="uac.manifest" ^
  --clean ^
  --add-data="clock.ico;." ^
  main.py

:: 检查打包结果
if %errorlevel% equ 0 (
    echo.
    echo ==============================================
    echo 打包成功!
    echo 可执行文件位置: %cd%\dist\时间同步工具.exe
    echo ==============================================
    :: 打开输出目录
    start dist
) else (
    echo.
    echo ==============================================
    echo 打包失败! 请查看上面的错误信息
    echo ==============================================
)

pause
