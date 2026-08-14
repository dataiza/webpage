# dataiza.sk

One-page bilingual (SK/EN) site for Dataiza s.r.o. Plain HTML/CSS, no build step,
no dependencies.

- `index.html` — the whole page. Translations live in `data-sk` / `data-en`
  attributes; ~10 lines of JS at the bottom swap them and remember the choice.
- `style.css` — palette in CSS custom properties, light + dark.
- `logo.svg` — favicon; the same mark is inlined in the header.
- `logo.png` — 512×512 raster of the same mark, for the OG/social preview and
  anywhere SVG isn't accepted. Regenerate with
  `rsvg-convert -w 512 -h 512 logo.svg -o logo.png`.
- `check.sh` — verifies every node has both languages. Run before pushing.

## Preview

```bash
xdg-open index.html   # no server needed
bash check.sh
```

## Deploy

Push to `main`. Pages serves the repo root — see [DEPLOY.md](DEPLOY.md) for the
custom-domain and DNS setup.

## Note

`IČ DPH` in the footer is `---` — fill it in if/when the company registers for
VAT.
