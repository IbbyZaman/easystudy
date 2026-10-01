@echo off
setlocal
cd /d "%~dp0"
title EasyStudy local server

echo.
echo ===============================
echo        EasyStudy Launcher
echo ===============================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is not installed or is not on PATH.
  echo Install the current Node.js LTS version from https://nodejs.org/
  echo Then run this file again.
  echo.
  pause
  exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
  echo npm could not be found. Reinstall Node.js LTS and try again.
  echo.
  pause
  exit /b 1
)

if not exist node_modules (
  echo First launch: installing packages. This can take a few minutes...
  call npm install
  if errorlevel 1 (
    echo.
    echo Package installation failed. Copy the error above and send it to ChatGPT.
    pause
    exit /b 1
  )
)

echo.
echo Starting EasyStudy at http://localhost:5173
start "" "http://localhost:5173"
echo Keep this window open while using EasyStudy.
echo Press Ctrl+C to stop the server.
echo.
call npm run dev -- --host 127.0.0.1 --port 5173

pause
