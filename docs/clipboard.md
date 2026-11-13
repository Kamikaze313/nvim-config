# Linux clipboard: yank here, paste anywhere

Selected behavior: ordinary Neovim yanks and pastes share the desktop clipboard
used by Ctrl-c/Ctrl-v in Linux applications. This uses Neovim's built-in
clipboard provider; no plugin or custom keymap is required.

## Configuration and automatic behavior

`lua/config/options.lua` sets `vim.opt.clipboard = "unnamedplus"` before plugins
load. This makes the `+` register the default for yank, delete, change, and put
operations that do not specify another register. Copying in another application
updates what Neovim's next `p` reads. A yank copies immediately, without saving
the file. Restart Neovim after changing the configuration.

Neovim automatically chooses `wl-copy`/`wl-paste` when `WAYLAND_DISPLAY` is set,
or an available X11 provider such as `xclip`/`xsel` when `DISPLAY` is set.
The `*` register remains the separate primary selection, commonly used for
middle-click paste; `"*p` reads that selection explicitly when supported.
Explicit named registers still work, for example `"ay` and `"ap`.

## Required dependencies

This device runs EndeavourOS on Wayland. `wl-copy` and `wl-paste` from
**wl-clipboard** are already installed; **xclip** is also installed for X11.
No package installation is needed here.

On another device, install the provider for its graphical session:

| Session | Required commands | Package | Example installation |
| --- | --- | --- | --- |
| Wayland | `wl-copy`, `wl-paste` | `wl-clipboard` | Arch/EndeavourOS: `sudo pacman -S wl-clipboard`; Debian/Ubuntu: `sudo apt install wl-clipboard`; Fedora: `sudo dnf install wl-clipboard`. |
| X11 | `xclip` (or `xsel`) | `xclip` (or `xsel`) | Arch/EndeavourOS: `sudo pacman -S xclip`; Debian/Ubuntu: `sudo apt install xclip`; Fedora: `sudo dnf install xclip`. |

Start Neovim from a terminal inside the graphical session so the provider can
reach the desktop. A remote SSH session or a console without a display needs
its own clipboard transport; these local desktop tools do not provide one.

## Controls and practical example

These are built-in keys, with their modes listed below. There is no clipboard
panel to open or close.

| Mode | Keys | Action |
| --- | --- | --- |
| Normal | `yy` | Copy the current line to the desktop clipboard. |
| Normal | `y{motion}` (for example `yiw`) | Copy the text covered by the motion (`yiw` copies the word under the cursor). |
| Normal → visual | `v` / `V` | Select characters / whole lines; move with normal motions. |
| Visual | `y` | Copy the selection and return to normal mode. |
| Normal | `p` / `P` | Paste after / before the cursor; linewise copies go below / above the current line. |
| Insert or command-line | `Ctrl-r`, then `+` | Insert text from the desktop clipboard. |
| Normal / visual | `"+y` / `"+p` | Explicitly copy to / paste from the desktop clipboard. |
| Normal | `"_dd` | Delete a line into the black-hole register, preserving the clipboard. |
| Normal | `"0p` | Paste the most recent Neovim yank, even after a later delete or desktop copy. |
| Visual | `P` | Replace the selection with clipboard text while preserving the clipboard for another paste. |
| Insert / visual | `Esc` | Return to normal mode or cancel the selection. |

Example, Neovim → Linux app:

1. Run `nvim example.txt`, press `i`, type `hello from Neovim`, then press `Esc`.
2. Press `yy` to copy the line, or select characters with `v` and motions, then
   press `y` to copy just that selection.
3. Switch to a desktop text field and press Ctrl-v. In most terminals, use
   Ctrl-Shift-v instead.

Example, Linux app → Neovim:

1. Select `hello from Linux` in another application and press Ctrl-c. Terminals
   usually use Ctrl-Shift-c to copy a selection.
2. Return to Neovim and press `p` in normal mode, or `i`, Ctrl-r, then `+` to
   insert at the cursor. Press `Esc` when finished.
3. Save with `:w`, then close the file with `:q`; use `:q!` to discard the example.

Ordinary `d`, `c`, and `x` also replace the desktop clipboard with removed text.
Use the `"_` prefix when you want to discard text while keeping your copy.
Visual `p` replaces the clipboard with the replaced text; use visual `P` when
you want to paste the same copied text repeatedly.

## Commands and troubleshooting

| Command | Purpose |
| --- | --- |
| `:set clipboard?` | Show the active setting; it should report `clipboard=unnamedplus`. |
| `:checkhealth vim.provider` | Check whether Neovim can find a clipboard provider. |
| `:echo provider#clipboard#Executable()` | Show the chosen provider; expect `wl-copy` in this Wayland session. |
| `:help clipboard` | Read the built-in provider documentation. |
| `:help clipboard-unnamedplus` | Read the option's behavior. |

In a Wayland shell, `wl-paste --no-newline` reads the desktop clipboard and
`printf 'hello from Linux' | wl-copy` sets it. On X11, use
`xclip -o -selection clipboard` to read and
`printf 'hello from Linux' | xclip -selection clipboard` to copy.
These are useful checks if an application and Neovim disagree about clipboard
contents. Health checks confirm tool availability; an actual copy/paste checks
connection to the desktop.

## Disabling

For this session, run `:set clipboard=`. Ordinary operations then use Neovim's
internal registers; explicit `"+y` and `"+p` can still access the desktop.
Run `:set clipboard=unnamedplus` to enable automatic sharing again.

To disable persistently, remove the documented `vim.opt.clipboard` setting from
`lua/config/options.lua` and restart Neovim. The provider packages can remain
installed for other applications.
