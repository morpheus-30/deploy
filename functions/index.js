const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const path = require("path");
const fs = require("fs");

const app = express();
app.use(cors({origin: true}));

// Serve the `index.html` with injected environment variables
app.get("**", (req, res) => {
  const indexPath = path.resolve(__dirname, "../public/index.html");
  let indexHtml = fs.readFileSync(indexPath, "utf8");

  // Inject environment variables into `index.html`
  indexHtml = indexHtml.replace(
      "<!-- FIREBASE_CONFIG -->",
      `<script>
      window.firebaseConfig = {
        apiKey: "${functions.config().env.firebase_api_key}",
        authDomain: "${functions.config().env.firebase_auth_domain}",
        projectId: "${functions.config().env.firebase_project_id}",
        storageBucket: "${functions.config().env.firebase_storage_bucket}",
    messagingSenderId: "${functions.config().env.firebase_messaging_sender_id}",
        appId: "${functions.config().env.firebase_app_id}"
        };

     </script>`,
  );

  res.set("Cache-Control", "public, max-age=600, s-maxage=1200");
  res.send(indexHtml);
});

exports.app = functions.https.onRequest(app);
