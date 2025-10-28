
# eternal_match

EternalMatch for dating and marriage app

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Eternal Token Server (Node.js)

This server generates Agora tokens dynamically for any user.

## 🚀 Setup

1. Run:
   bash
   npm install
2. Add your Agora App ID and Certificate in `server.js`.
3. Start the server:
   bash
   npm start
4. Test locally:
   http://localhost:3000/token?uid=1&channel=test

## 🌍 Deployment on Render

1. Create a new Web Service on [Render.com](https://render.com)
2. Connect your GitHub repository with this folder
3. Build Command: (leave empty)
4. Start Command:
   node server.js
5. After deployment, use your link in Flutter:
   https://your-render-link.onrender.com/token?uid=1&channel=test

✅ Done — your global token server is ready!
 8d0868c6f3c2c1a172bea77fa1561c5893115d49
