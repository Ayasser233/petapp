# Pet App – WhatsApp Support Bot

Firebase Cloud Functions webhook that receives WhatsApp messages from customers,
stores them in Firestore, and auto-replies via the WhatsApp Cloud API until a
human agent takes over through the external dashboard.

Customers **never chat inside the Flutter app** — the app only opens WhatsApp
with your business number.  All conversation happens in WhatsApp itself.

---

## Files

| File | Purpose |
|------|---------|
| `functions/index.js` | Cloud Function: `whatsappWebhook` (GET + POST) |
| `functions/package.json` | Node 20 dependencies |
| `functions/.env.example` | Template for non-secret env vars |
| `functions/.gitignore` | Keeps `node_modules/` and `.env` out of git |
| `firestore.indexes.json` | Compound index for chat lookup query |
| `firebase.json` | Firebase project config (functions + indexes) |
| `.firebaserc` | Default Firebase project alias |

---

## 1 · One-time Setup

### Install Firebase CLI
```bash
npm install -g firebase-tools
firebase login
```

### Install function dependencies
```bash
cd functions
npm install
cd ..
```

---

## 2 · Set Secrets (Google Secret Manager)

```bash
# Your WhatsApp Cloud API permanent access token (from Meta Business)
firebase functions:secrets:set WHATSAPP_TOKEN

# A random string you choose — paste it into Meta's webhook config too
firebase functions:secrets:set WEBHOOK_VERIFY_TOKEN
# e.g.: openssl rand -hex 32
```

---

## 3 · Set Non-Secret Config

```bash
cp functions/.env.example functions/.env
# Edit functions/.env:
#   PHONE_NUMBER_ID=123456789012345   ← from Meta → WhatsApp → API Setup
```

---

## 4 · Deploy

```bash
# From repo root (petapp/)
firebase deploy --only functions,firestore:indexes
```

Deployed function URL:
```
https://us-central1-aleefyapp-bb4fd.cloudfunctions.net/whatsappWebhook
```

---

## 5 · Register Webhook in Meta Dashboard

1. Go to [Meta for Developers](https://developers.facebook.com) → your App
2. Left sidebar: **WhatsApp → Configuration**
3. Under **Webhook**, click **Edit**
4. Set:
   - **Callback URL**: `https://us-central1-aleefyapp-bb4fd.cloudfunctions.net/whatsappWebhook`
   - **Verify Token**: the value you set for `WEBHOOK_VERIFY_TOKEN`
5. Click **Verify and Save**
6. Under **Webhook Fields**, enable: ✅ **messages**

---

## 6 · Firestore Data Model

### `whatsapp_support_chats/{chatId}`

| Field | Type | Notes |
|---|---|---|
| `customerPhone` | string | E.164 without '+', e.g. `"201234567890"` |
| `customerName` | string? | Back-filled from WhatsApp profile if present |
| `lastMessage` | string? | Snippet of most recent message |
| `status` | string | `waiting_support` · `in_progress` · `resolved` |
| `botEnabled` | bool | `true` = bot replies; `false` = silent |
| `humanTakenOver` | bool | `true` = human agent is handling the chat |
| `source` | string | Always `"whatsapp"` |
| `createdAt` | Timestamp | |
| `updatedAt` | Timestamp | |

### `whatsapp_support_chats/{chatId}/messages/{messageId}`

| Field | Type | Notes |
|---|---|---|
| `chatId` | string | Parent chat ID |
| `sender` | string | `customer` · `bot` · `support` · `developer` |
| `text` | string | |
| `type` | string | `text` (extend later for image, audio, etc.) |
| `whatsappMessageId` | string? | Raw Meta message ID for dedup / audit |
| `createdAt` | Timestamp | |

---

## 7 · How to Disable the Bot (Human Takeover)

From your external dashboard or any Firestore admin client:

```javascript
await db.collection("whatsapp_support_chats").doc(chatId).update({
  botEnabled:     false,
  humanTakenOver: true,
  status:         "in_progress",
  updatedAt:      Timestamp.now(),
});
```

The webhook re-reads both flags on **every incoming message**.
The change takes effect instantly — no redeployment needed.

To re-enable the bot after the case is closed:
```javascript
await db.collection("whatsapp_support_chats").doc(chatId).update({
  botEnabled:     true,
  humanTakenOver: false,
  status:         "waiting_support",
  updatedAt:      Timestamp.now(),
});
```

---

## 8 · Firestore Index

Required for the chat-lookup query (`customerPhone + source + orderBy updatedAt`):

```
Collection : whatsapp_support_chats
Fields     : customerPhone ASC · source ASC · updatedAt DESC
```

Already defined in `firestore.indexes.json`. Deployed with:
```bash
firebase deploy --only firestore:indexes
```

---

## 9 · Test

```bash
# Verify handshake manually:
curl "https://us-central1-aleefyapp-bb4fd.cloudfunctions.net/whatsappWebhook\
?hub.mode=subscribe\
&hub.verify_token=YOUR_VERIFY_TOKEN\
&hub.challenge=test123"
# Expected response: test123
```

Then send a WhatsApp message to your business number.
Check Firestore → `whatsapp_support_chats` for the new document and messages subcollection.

---

## 10 · Extend Later

| Feature | Where to change |
|---|---|
| AI replies | Replace `chooseAutoReply()` with an OpenAI / Gemini call |
| More bot rules | Add entries to `AUTO_REPLY_RULES` array |
| Image / audio handling | Add cases in `parseIncomingMessage()` where `message.type !== "text"` |
| WhatsApp template messages | Change `sendWhatsAppMessage()` payload `type` to `"template"` |
| Outbound messages from dashboard | Add a second Cloud Function triggered by Firestore writes |
