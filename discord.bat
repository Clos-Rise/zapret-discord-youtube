@echo off
chcp 65001 >nul
:: 65001 - UTF-8

:: Path check
set scriptPath=%~dp0
set "path_no_spaces=%scriptPath: =%"
if not "%scriptPath%"=="%path_no_spaces%" (
    echo Путь содержит пробелы.
    echo Пожалуйста, переместите скрипт в директорию без пробелов.
    pause
    exit /b
)

set BIN=%~dp0bin\

if not exist "%BIN%winws.exe" (
    echo Файл %BIN%winws.exe не найден.
    pause
    exit /b
)

if not exist "%~dp0list-discord.txt" (
    echo Файл %~dp0list-discord.txt не найден.
    pause
    exit /b
)

if not exist "%BIN%quic_initial_www_google_com.bin" (
    echo Файл %BIN%quic_initial_www_google_com.bin не найден.
    pause
    exit /b
)

if not exist "%BIN%tls_clienthello_www_google_com.bin" (
    echo Файл %BIN%tls_clienthello_www_google_com.bin не найден.
    pause
    exit /b
)

start "zapret: discord" /min "%BIN%winws.exe" ^
--wf-tcp=443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist="%~dp0list-discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0list-discord.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin"
