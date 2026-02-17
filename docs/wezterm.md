# WezTerm Configuration

## Appearance

| Setting | Value |
|---|---|
| Color scheme | AdventureTime |
| Font | FiraCode Nerd Font (Medium) |
| Font size | 10, line height 1.1, cell width 0.9 |
| Window | 140×35, title bar + resize, 97% opacity |
| Cursor | Blinking bar (500ms) |
| Padding | 12px sides, 8px top/bottom |

## Tab Bar

- Bottom-positioned, retro style
- Auto-hidden with single tab
- Right status shows **cwd + time**

## Leader Key: `Ctrl+Space` (1s timeout)

All keybindings below are prefixed with the leader key. Press `Ctrl+Space`, release, then press the key.

> **Note:** `Ctrl+Space` can conflict with input method switching (ibus) on Ubuntu.
> Common alternatives: `Ctrl+A`, `Ctrl+B`, or `Ctrl+S`.

### Panes

| Keys | Action |
|---|---|
| `Leader \` | Split horizontal |
| `Leader -` | Split vertical |
| `Leader x` | Close pane (with confirmation) |
| `Leader h/j/k/l` | Navigate panes ←↓↑→ |
| `Leader H/J/K/L` | Resize panes ←↓↑→ |
| `Leader z` | Zoom / unzoom pane |

### Tabs

| Keys | Action |
|---|---|
| `Leader t` | New tab |
| `Leader n` | Next tab |
| `Leader p` | Previous tab |
| `Leader 1-5` | Jump to tab by number |
| `Leader r` | Rename tab |

### Utilities

| Keys | Action |
|---|---|
| `Leader f` | Toggle fullscreen |
| `Leader y` | Enter copy mode |
| `Leader Space` | Quick select (URLs, hashes, IPs, etc.) |
| `Leader /` | Search in scrollback |

### Clipboard (no leader needed)

| Keys | Action |
|---|---|
| `Ctrl+V` | Paste from clipboard |
| `Ctrl+Shift+C` | Copy to clipboard |

## Mouse

| Action | Behavior |
|---|---|
| Triple-click | Select entire command output (requires shell integration) |
| Click on URL/path | Opens link (file paths like `./src/main.rs:10` are clickable) |

## Scrollback

10,000 lines of scrollback history.
