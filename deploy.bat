@echo off
SET PATH=%PATH%;D:\flutter\bin
echo ==========================================
echo MultiProServices - Deployment Script
echo ==========================================

echo 1. Checking tools...
call flutter --version
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not found in PATH. Please install Flutter or fix PATH.
    pause
    exit /b
)
call firebase --version
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Firebase CLI is not found in PATH. Please install Firebase Tools.
    echo Run: npm install -g firebase-tools
    pause
    exit /b
)

echo 2. Login to Firebase...
call firebase login

echo 3. Building Flutter Web App...
cd frontend
call flutter pub get
call flutter build web
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed.
    pause
    exit /b
)
cd ..

echo 4. Deploying to Firebase Hosting...
call firebase deploy --only hosting --project multi-pro-services

echo ==========================================
echo Deployment Complete!
echo Your public URL should be listed above.
echo ==========================================
pause
