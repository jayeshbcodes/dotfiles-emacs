# Emacs Cheatsheet — minimal setup + Rust + Claude Code pairing

Notation: `C-x` = Ctrl+x, `M-x` = Alt+x (or Esc then x), `C-x C-f` = hold Ctrl, press x then f.

**Dont know a key sequence? Press the start and pause.** `which-key` pops up
a menu of every valid next key after any prefix (`C-x`, `C-c`, Magit's `c`/`b`/`l`,
anything). Use this instead of memorizing — it's covered below but applies
everywhere in this config.

## File & buffer navigation

A "buffer" is whatever's in a window — a visited file, `*scratch*`, the Magit
status, a shell, etc. Files you open become buffers; buffers aren't always
files.

| Keys | Action |
|---|---|
| `C-x C-f` | Open (find) file — creates it if it doesn't exist yet |
| `C-x C-s` | Save current buffer |
| `C-x C-w` | Save current buffer as (new filename) |
| `C-x s` | Save all modified buffers, asking for each |
| `C-x d` | Open Dired — a file browser for a directory (`n`/`p` to move, `Enter` to open, `g` to refresh) |
| `C-x b` | Switch to another buffer (type name, or Tab-complete) |
| `C-x C-b` | List all open buffers in a buffer picker |
| `C-x <left>` / `C-x <right>` | Cycle to previous / next buffer |
| `C-x k` | Kill (close) current buffer |
| `C-x 0` | Close current window (buffer stays open elsewhere) |
| `C-x 1` | Close other windows (keep only this one) |
| `C-x 2` | Split window horizontally (stacked, top/bottom) |
| `C-x 3` | Split window vertically (side by side) |
| `C-x o` | Move point to the other window |
| `C-x 4 f` | Open a file in a new window (leaves current window as-is) |
| `C-g` | Cancel current command (universal "get me out") |
| `M-x` | Run any command by name |
| `C-x C-c` | Quit Emacs |

## Editing basics

Cursor movement:

| Keys | Action |
|---|---|
| `C-f` / `C-b` | Forward / backward one character |
| `M-f` / `M-b` | Forward / backward one word |
| `C-n` / `C-p` | Next / previous line |
| `C-a` / `C-e` | Start / end of line |
| `M-a` / `M-e` | Start / end of sentence |
| `M-<` / `M->` | Start / end of buffer |
| `C-v` / `M-v` | Page down / page up |
| `C-l` | Recenter screen on point (cycles top/center/bottom) |

Selecting, cutting, copying:

| Keys | Action |
|---|---|
| `C-space` | Set mark (start a selection at point, move cursor to extend it) |
| `C-w` | Cut (kill) selected region |
| `M-w` | Copy selected region |
| `C-y` | Paste (yank) last cut/copied text |
| `M-y` | After `C-y`, cycle back through earlier kills (clipboard history) |
| `C-k` | Kill from point to end of line |
| `M-d` | Kill (delete) the next word |
| `C-M-\` | Indent the whole selected region (`Tab` alone only indents the current line) |
| `C-/` or `C-x u` | Undo |

Search & replace:

| Keys | Action |
|---|---|
| `C-s` / `C-r` | Search forward / backward (incremental — type to filter, repeat key for next match) |
| `M-%` | Query-replace (asks `y`/`n`/`!` per match) |

Misc:

| Keys | Action |
|---|---|
| `C-x C-+` / `C-x C--` | Increase / decrease font size |
| `F5` | Toggle dark/light theme (`modus-vivendi` / `modus-operandi`) |

## Discoverability — `which-key`

Press any prefix key (`C-x`, `C-c`, a Magit letter like `c` or `b`) and **pause**
half a second instead of following it with a guess. A small window appears at
the bottom listing every valid next key and what it does. This replaces
memorizing most of this cheatsheet — use it any time you're unsure.

## Rust workflow (via `eglot` + `rust-mode` + `company`)

`eglot` starts automatically when you open a `.rs` file (needs `rust-analyzer`, already installed). Eglot ships with almost no default keybindings upstream — `C-c C-a`, `C-c C-r`, `M-n`/`M-p` below are bound explicitly in `init.el`, not stock Eglot defaults.

A ⚡-style icon appears in the margin next to a line when a code action (quick fix) is available there — that's `eglot-code-action-indications`, not an error.

| Keys | Action |
|---|---|
| `M-.` | Jump to definition |
| `M-,` | Jump back |
| `C-c C-r` | Rename symbol (`eglot-rename`) |
| `C-c C-a` | Show code actions (quick fixes) |
| `M-n` / `M-p` | Next / previous error or warning (`flymake`) |
| `C-h .` | Show docs for symbol at point |
| — | File auto-formats with `rustfmt` on save |

Autocomplete (`company-mode`, popup appears automatically as you type):

| Keys | Action |
|---|---|
| — | Popup appears after a short pause once you start typing |
| `C-n` / `C-p` | Next / previous candidate |
| `Enter` | Accept the selected candidate |
| `Tab` | Complete to the longest common text among candidates; press again to cycle |
| `C-g` | Dismiss popup without accepting |
| `M-/` | Manually trigger the popup (if it didn't fire on its own) |

Cargo, run from a shell or `M-x compile`:

- `M-x compile` then `cargo check` — fast type-check, errors shown in a buffer
- `M-x compile` then `cargo test`
- Click/`Enter` on an error line in the `*compilation*` buffer jumps to that spot

## Reviewing Claude's diffs — `magit` (the main pairing workflow)

Open with `C-x g` from any file in a repo. Inside the Magit status buffer:

| Keys | Action |
|---|---|
| `C-x g` | Open Magit status (see all changes) |
| `g` | Refresh the status buffer (e.g. after Claude edits more files) |
| `TAB` | Expand/collapse a diff hunk under point |
| `s` | **S**tage the file/hunk at point |
| `u` | **U**nstage the file/hunk at point |
| `S` | Stage everything |
| `U` | Unstage everything |
| `k` | **K**ill/discard the change at point, reverts to last commit (⚠️ `x` looks tempting but is `magit-reset`, a different and more dangerous command — don't use it for this) |
| `c` then pause | Opens the commit menu (mnemonic-per-letter, read it — don't memorize) |
| `c c` | → Create commit from staged changes (opens message buffer) |
| `c a` | → **A**mend: fold currently staged changes into the *previous* commit instead of making a new one |
| `C-c C-c` | Inside the message buffer: confirm and finalize the commit |
| `l l` | Show commit log; `Enter` on a commit shows its full diff (opens yet another buffer) |
| `q` | Quit back to your previous window |

Buffer pile-up: clicking through several commits in the log opens a new
buffer each time rather than replacing the last one, and windows can end up
split along the way. If you lose track of your file buffer, don't chase `q`
through the stack — just jump straight there: `C-x 1` (declutter to one
window) then `C-x b`, type the filename, `Enter`.

Note: `c c` (Magit's commit menu → create) and `C-c C-c` (the universal
Emacs "finish editing this buffer" convention, also used for email drafts
and org captures) look similar but are unrelated — first one opens the
message buffer, second one submits what you typed into it.

Since files edited by Claude on disk are picked up automatically (`global-auto-revert-mode` is on), you can leave a file open in Emacs, let Claude edit it, and it'll just refresh — no manual reload needed.

## Partial commits — accepting only some of what Claude changed

A file can be **partially staged**: stage one hunk (`s` on it), leave another
hunk unstaged, and Magit shows the same file under both "Staged changes" and
"Unstaged changes" at once. Commit (`c c`) and only the staged hunk goes in —
the rest stays pending for later, or gets discarded (`k`) if you don't want it.
This is the normal way to accept part of a multi-file/multi-hunk change from
Claude without an all-or-nothing decision.

## Typical review loop

1. Claude Code makes changes on disk.
2. `C-x g` (or `g` to refresh) → Magit status shows what changed.
3. `TAB` on a file to expand its diff, hunk by hunk.
4. Per hunk: `s` to stage what you accept, `k` to discard what you don't, or leave it unstaged to decide later.
5. `c c` to commit whatever's staged — repeat as more hunks get resolved.

## Viewing Markdown (`markdown-mode`)

Opening any `.md` file automatically uses `gfm-mode` (GitHub-flavored Markdown:
tables, fenced code blocks). This cheatsheet itself is a `.md` file — try it
on `~/.emacs.d/CHEATSHEET.md`.

| Keys | Action |
|---|---|
| `F6` | Toggle live preview **inside Emacs** (via `eww`) — re-renders each time you save (`C-x C-s`), not on every keystroke |
| `C-c C-c p` | Export and open the rendered version in your external browser |
| `C-c C-c e` | Export to an HTML file only (doesn't open anything) |

## Notes

- Config lives in `~/.emacs.d/init.el` (and `~/.emacs.d/early-init.el` for startup UI tweaks).
- External packages: `magit`, `rust-mode`, `which-key`, `company`, `markdown-mode`. Everything else (`eglot`, `flymake`, `use-package`, `modus-themes`) is built into Emacs 31.
- To add a package later: add a `(use-package NAME ...)` block to `init.el`, save, then `M-x eval-buffer` or restart Emacs.
- Every keybinding in this document was verified against this exact config's live keymaps, not assumed from memory.
