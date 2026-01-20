# Deployment Troubleshooting Guide

If the `deploy.bat` script is not giving you a URL, it is likely due to one of these reasons:

## 1. Tools Not Installed
You **must** have these tools installed on your computer for the script to work:
-   **Flutter SDK**: [Download Here](https://docs.flutter.dev/get-started/install/windows)
-   **Node.js (for Firebase)**: [Download Here](https://nodejs.org/)

To check if you have them, open a new terminal (Command Prompt or PowerShell) and type:
```bash
flutter --version
node --version
firebase --version
```
If any of these say "command not found" or "not recognized", the script will fail.

## 2. "npm is not recognized" Error
This means **Node.js** is not installed.
1.  **Download Node.js**: Go to [nodejs.org](https://nodejs.org/) and download the "LTS" version for Windows.
2.  **Install**: Run the installer and click Next through all steps.
3.  **Restart**: Close your terminal/command prompt and open a new one.
4.  **Verify**: Type `node -v` and `npm -v` to check if it works.

## 3. "flutter is not recognized" Error
This means **Flutter SDK** is not installed or not in your PATH.

**Option A: Install via Winget (Recommended)**
1.  Open terminal and run: `winget install Google.Flutter`
2.  **Restart Terminal**: Close and reopen to refresh PATH.

**Option B: Manual Install**
1.  Download from [docs.flutter.dev](https://docs.flutter.dev/get-started/install/windows).
2.  Extract the zip file to `C:\src\flutter` (create folder if needed).
3.  Add `C:\src\flutter\bin` to your **System Environment Variables Path**.

**How to add to Path (Windows):**
1.  Press **Windows Key**, type **"env"**, and select **"Edit the system environment variables"**.
2.  Click the **"Environment Variables..."** button at the bottom right.
3.  In the top section (**User variables**), find the variable named **"Path"** and select it.
4.  Click **"Edit..."**.
5.  Click **"New"** on the right side.
6.  Paste the full path to your flutter bin folder (e.g., `C:\src\flutter\bin`).
7.  Click **OK** on all three open windows.
8.  **Important**: Close your existing terminal and open a new one.

## 4. Login Required
You need to be logged in to Firebase for the deployment to authorize.
Run this command in your terminal:
```bash
firebase login
```
A browser window will open. Login with the Google Account that owns the `multi-pro-services` project.

## 3. Project ID Mismatch
Make sure your project ID in `frontend/lib/firebase_options.dart` matches the one in `.firebaserc` (if it exists) or the one you selected.
The script assumes your project is named `multi-pro-services`. If it's different (e.g., `multi-pro-services-123`), you need to run:
```bash
firebase use --add
# Select your actual project alias
```

## 4. Build Failed
If the Flutter build fails, there is no web app to deploy.
Try running the build manually to see the errors:
```bash
cd frontend
flutter build web
```
Fix any errors shown here first.

## 5. "It's still not working"
Please copy the **exact text** from the terminal window when you run `deploy.bat` and paste it here so I can deduce the error.
