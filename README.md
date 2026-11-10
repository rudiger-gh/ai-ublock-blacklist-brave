# AI uBlock Blacklist, Brave-compatible mirror

An automatically updated copy of [alvi-se/ai-ublock-blacklist](https://github.com/alvi-se/ai-ublock-blacklist) that Brave's ad blocker can read.

Upstream tags every rule with uBlock Origin's `reason="…"` option, for example `||example.com^$doc,reason="AI slop"`. Brave's engine, [adblock-rust](https://github.com/brave/adblock-rust), rejects rules with that option, so Brave loads none of the upstream list. This mirror removes the option and changes nothing else. Each rule still blocks navigation to the listed site and leaves its resources on other sites alone.

## Use in Brave

Add this URL under **Custom filter lists** in `brave://settings/shields/filters`:

```
https://raw.githubusercontent.com/rudiger-gh/ai-ublock-blacklist-brave/main/list.txt
```

## How it updates

A GitHub Actions workflow runs every six hours. It downloads the upstream `list.txt`, strips `reason=`, and commits `list.txt` only when the result changed. The workflow refuses to publish if the converted list has fewer than 1,000 rules or still contains `reason=`, so a broken upstream file leaves the last good copy in place.

Report sites to add or remove upstream, not here.

## Licence

GPL-3.0, the same as upstream. The list content belongs to the upstream contributors.
