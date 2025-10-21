// Eternal Token Server (Node.js)
// Generates Agora tokens dynamically

const express = require("express");
const cors = require("cors");
const { RtcTokenBuilder, RtcRole } = require("agora-access-token");

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Server configuration
const PORT = 3000;

// ضع هنا App ID و App Certificate الخاصين بك من Agora
const APP_ID = "b9cc185dc37e4e62b1494ace01c08778";
const APP_CERTIFICATE = "ac87581eb1c94ba7bab4ba765de19e88";

// Endpoint لتوليد Token
app.get("/token", (req, res) => {
  const uid = req.query.uid;
  const channel = req.query.channel;

  if (!uid || !channel) {
    return res.status(400).json({ error: "Missing uid or channel" });
  }

  // صلاحية التوكن: 24 ساعة
  const expirationTimeInSeconds = 24 * 60 * 60;
  const currentTimestamp = Math.floor(Date.now() / 1000);
  const privilegeExpireTs = currentTimestamp + expirationTimeInSeconds;

  // توليد التوكن
  const token = RtcTokenBuilder.buildTokenWithUid(
    APP_ID,
    APP_CERTIFICATE,
    channel,
    Number(uid),
    RtcRole.PUBLISHER,
    privilegeExpireTs
  );

  return res.json({ token });
});

// تشغيل السيرفر
app.listen(PORT, () => {
  console.log(`✅ Eternal Token Server running on port ${PORT}`);
});
