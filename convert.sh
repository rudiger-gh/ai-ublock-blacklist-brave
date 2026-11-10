#!/bin/sh
# Rebuild list.txt from upstream alvi-se/ai-ublock-blacklist in a form Brave's adblock-rust parses.
# Upstream tags every rule with reason="...", an option adblock-rust rejects; this drops that option only.
set -eu
UPSTREAM=https://raw.githubusercontent.com/alvi-se/ai-ublock-blacklist/master/list.txt
tmp=$(mktemp)
curl -fsSL --retry 3 "$UPSTREAM" -o "$tmp"
{
  echo '! Title: AI uBlock Blacklist (Brave-compatible mirror)'
  echo '! Expires: 1 day'
  echo '! Homepage: https://github.com/rudiger-gh/ai-ublock-blacklist-brave'
  echo "! Source: $UPSTREAM"
  echo '! License: GPL-3.0, as upstream'
  grep -v -E '^! (Title|Expires|Homepage):' "$tmp" \
    | sed -E 's/,reason="[^"]*"//; s/\$reason="[^"]*"$//'
} > list.txt.new
rm -f "$tmp"
rules=$(grep -c '^||' list.txt.new || true)
# Refuse to publish a broken or truncated list.
if [ "$rules" -lt 1000 ] || grep -q 'reason=' list.txt.new; then
  echo "conversion check failed: $rules rules" >&2; rm -f list.txt.new; exit 1
fi
mv list.txt.new list.txt
echo "$rules rules"
