@echo off
echo Seeding Firestore Database...
echo Make sure you are running Firebase Emulators or have service-account.json
cd backend
node seed_data.js
pause
