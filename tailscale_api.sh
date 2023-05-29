#!/bin/sh
# install tailscale via api
# Kacper Lipka 2023

# Zdefiniuj zmienne
SERVER_IP="192.168.1.82" 
API_TOKEN=api_token # ścieżka do pliku z tokenem API
API_TOKEN=$(cat $API_TOKEN)
AUTH_KEY="klucz_tailscale" # klucz uwierzytelniający Tailscale
ADVERTISE_ROUTES="192.168.1.82/32"

# Zakoduj login:haslo w standardzie Base64
AUTH=$(echo "$CREDENTIALS" | tr -d '\n' | base64)

# Wyślij zapytanie do serwera, które zainstaluje aplikacje
curl -X 'POST' "http://$SERVER_IP/api/v2.0/chart/release" \
    -H 'accept: application/json' \
    -H "Authorization: Bearer $API_TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{
  "catalog": "OFFICIAL",
  "train": "community",
  "item": "tailscale",
  "release_name": "my-tailscale-release",
  "version": "1.0.2",
  "values": {
    "tailscaleConfig": {
      "authkey": "'$AUTH_KEY'",
      "advertiseRoutes": [
        "'$ADVERTISE_ROUTES'"
      ]
    }
  }
}'
