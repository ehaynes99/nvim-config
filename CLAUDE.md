# herdr

## API

Not in `herdr --help`; from `herdr api schema` plus experiment.

- `$HERDR_SOCKET_PATH` is the real API, newline-delimited JSON. `layout.apply`, `layout.export`,
  `layout.set_split_ratio` and `pane.focus` have no CLI equivalent.
- `layout.apply` rebuilds the tab from scratch: panes destroyed, processes killed, new tab id, and a
  requested `pane_id` ignored. Non-destructive rearranging is `pane swap` / `pane move` /
  `layout.set_split_ratio`.
- `ratio` is the fraction given to `first`; `first` is the left (or top) pane.
- A pane whose command exits is destroyed — hence the `bash -lc '…; exec bash'` wrappers.
- Pane ids change after `pane move`. Resolve live, never cache.

## Rendering

A new pane is spawned at the whole tab's width and narrowed to its share of the split ~250ms later.
Anything painting in that window leaves a wrong-width frame on the host terminal.
`~/.config/herdr/dev-layout.sh` holds each pane's program until `stty size` changes, then clears.
Nothing in nvim is needed — don't add it back.

`pane read --source visible` stays clean and correctly sized throughout, which looks like
host-surface corruption (herdrdev/herdr#3672) but isn't. Don't re-chase that.

## Testing

nvim renders on the alternate screen, so driving its TUI through herdr keystrokes is a dead end.
Test headlessly with faked pane env:

```bash
HERDR_PANE_ID=wX:pN HERDR_WORKSPACE_ID=wX nvim --headless -u NONE \
  --cmd "set rtp+=$HOME/.config/nvim" README.md -c "42" \
  -c "lua print(require('utils.herdr').line_ref())" -c q
```

`layout.apply` kills running processes without asking — use a throwaway workspace.
