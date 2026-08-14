# Deploying to GitHub Pages on dataiza.sk

The site is plain static files at the repo root — no build step. Pushing to
`main` publishes it.

---

## 1. Publish on the default domain first

Repo → **Settings → Pages → Source: Deploy from a branch** → branch `main`,
folder `/ (root)` → **Save**.

Wait a minute, then open `https://dataiza.github.io/webpage/`.

Do this *before* touching DNS. If you point the domain first and something is
broken, you cannot tell a DNS problem from a Pages problem.

## 2. DNS records at the registrar — already done

Verified on 2026-08-14: the apex resolves to all four GitHub edges and
`www.dataiza.sk` is a CNAME to `dataiza.github.io.` Nothing to change; the table
below is the reference for what is set (and what to restore if it ever breaks).

The AAAA records are not required and may or may not be present.

`.sk` domains are managed through the registrar's panel (Websupport, ACTIVE24,
…). An apex domain cannot use a CNAME record, so the apex gets A/AAAA records
and only `www` gets a CNAME:

| Type  | Host / Name | Value                  | TTL  |
|-------|-------------|------------------------|------|
| A     | `@`         | `185.199.108.153`      | 3600 |
| A     | `@`         | `185.199.109.153`      | 3600 |
| A     | `@`         | `185.199.110.153`      | 3600 |
| A     | `@`         | `185.199.111.153`      | 3600 |
| AAAA  | `@`         | `2606:50c0:8000::153`  | 3600 |
| AAAA  | `@`         | `2606:50c0:8001::153`  | 3600 |
| AAAA  | `@`         | `2606:50c0:8002::153`  | 3600 |
| AAAA  | `@`         | `2606:50c0:8003::153`  | 3600 |
| CNAME | `www`       | `dataiza.github.io.` | 3600 |

Notes:

- All four A records are needed — they are GitHub's anycast edges, not
  alternatives to each other.
- The AAAA (IPv6) records are recommended but optional; skip them if the panel
  refuses IPv6.
- The CNAME value is the **account** host — `dataiza.github.io.` — never
  `dataiza.github.io/webpage`.
- Delete any leftover parking/redirect record on `@`, and any `www` A record.
  A host cannot have both a CNAME and other records.
- Re-check the IPs against GitHub's current *"Managing a custom domain for your
  GitHub Pages site"* docs before entering them — the edge addresses have
  changed historically.

## 3. Tell GitHub the domain

The `CNAME` file in this repo (containing `dataiza.sk`) *is* the custom-domain
setting. Alternatively enter the domain under **Settings → Pages → Custom
domain → Save**, which commits the same file for you. Don't fight the two.

## 4. DNS check and HTTPS certificate

Settings → Pages shows *"DNS check in progress"*, then a green check.
Let's Encrypt issuance takes anywhere from a few minutes to ~24 h.

Once it's done, tick **Enforce HTTPS**. It stays greyed out until the
certificate exists — that's expected, not a failure.

## 5. Verify

```bash
dig +short dataiza.sk A                      # → the four 185.199.x.153 addresses
dig +short www.dataiza.sk CNAME              # → dataiza.github.io.
curl -sSI https://dataiza.sk | head -n 1     # → HTTP/2 200
curl -sSI http://www.dataiza.sk | head -n 3  # → 301 → https://dataiza.sk
```

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| *"Domain does not resolve to the GitHub Pages server"* | DNS not propagated yet (wait out the old TTL), or a stale parking record still on `@`. |
| 404 although DNS is correct | The `CNAME` file was dropped by a force-push or branch switch. Pages silently reverts to the default domain when it disappears. |
| Certificate / TLS error | *Enforce HTTPS* was ticked before the cert issued, or a `CAA` record on the domain blocks Let's Encrypt. Untick, wait, re-tick. |
| Apex works, `www` doesn't (or vice versa) | GitHub only redirects between the two when both DNS sides exist. Add the missing record. |
| Someone else could claim the domain | Optional but recommended: **Settings → Pages → Verify domain**, which asks for a `_github-pages-challenge-dataiza` TXT record. |
