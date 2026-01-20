# MultiProServices

A production-ready, full-stack, real-time on-demand multi-service platform built with Flutter Web, Firebase, and Vertex AI.

## 🚀 Features

-   **User**: Service discovery, Real-time Map tracking, Booking flow.
-   **Provider**: Dashboard, Online/Offline toggle, Real-time request acceptance.
-   **AI Integration**: Vertex AI for service recommendations and smart matching.
-   **Real-time**: Powered by Firebase Firestore listeners.

## 🛠️ Tech Stack

-   **Frontend**: Flutter Web (GoRouter, Provider, Google Maps)
-   **Backend**: Firebase Cloud Functions (Node.js)
-   **Database**: Cloud Firestore
-   **AI**: Google Cloud Vertex AI

## 🏗️ Setup & Installation

### Prerequisites
1.  Flutter SDK installed.
2.  Node.js installed.
3.  Firebase CLI installed (`npm install -g firebase-tools`).

### Steps

1.  **Clone the repository** (if applicable).
2.  **Frontend Setup**:
    ```bash
    cd frontend
    flutter pub get
    ```
3.  **Backend Setup**:
    ```bash
    cd backend
    npm install
    ```
4.  **Firebase Configuration**:
    -   Create a project in [Firebase Console](https://console.firebase.google.com/).
    -   Enable **Authentication** (Email/Google).
    -   Enable **Firestore Database**.
    -   Enable **Functions**.
    -   Run `flutterfire configure` in the `frontend` directory to generate `firebase_options.dart`.
    -   Update `web/index.html` with your Google Maps API Key in the script tag (add it manually).

### Running the App

1.  **Run Backend Emulators** (Optional but recommended):
    ```bash
    firebase emulators:start
    ```
2.  **Run Frontend**:
    ```bash
    cd frontend
    flutter run -d chrome --web-renderer html
    ```

## 🌍 Deployment

To make your website live on the internet:

1.  **Login to Firebase**:
    ```bash
    firebase login
    ```
2.  **Initialize Hosting**:
    ```bash
    firebase init hosting
    # Select 'Use an existing project' -> Your Project
    # Public directory: build/web
    # Configure as single-page app: Yes
    ```
3.  **Build & Deploy**:
    ```bash
    cd frontend
    flutter build web
    firebase deploy --only hosting
    ```
    The terminal will output your **Hosting URL** (e.g., `https://your-project.web.app`).

## 🤖 Vertex AI Integration

The backend is configured to use Vertex AI. Ensure you enable the Vertex AI API in your Google Cloud Console.
The `backend/index.js` contains the placeholder integration.

## 📱 Screenshots

(Add screenshots of Home, Login, and Dashboard here)
