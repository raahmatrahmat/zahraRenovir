#!/data/data/com.termux/files/usr/bin/bash

# === CONFIGURASI ===
APP_ID=1683828
INSTALLATION_ID=GANTI_DENGAN_INSTALLATION_ID
PRIVATE_KEY_PATH="./private-key.pem"

# === AMBIL JWT TOKEN ===
header=$(echo -n '{"alg":"RS256","typ":"JWT"}' | openssl base64 -e | tr -d '\n=' | tr '/+' '_-')
now=$(date +%s)
iat=$((now - 60))
exp=$((now + 600))
payload=$(echo -n "{\"iat\":$iat,\"exp\":$exp,\"iss\":$APP_ID}" | openssl base64 -e | tr -d '\n=' | tr '/+' '_-')

unsigned_token="${header}.${payload}"
signature=$(echo -n "$unsigned_token" | openssl dgst -sha256 -sign "$PRIVATE_KEY_PATH" | openssl base64 -e | tr -d '\n=' | tr '/+' '_-')
JWT="${unsigned_token}.${signature}"

# === AMBIL INSTALLATION TOKEN ===
curl -s -X POST \
  -H "Authorization: Bearer $JWT" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/app/installations/$INSTALLATION_ID/access_tokens" | jq -r .token

