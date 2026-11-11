# Backup and recovery

Archive, relative to this configuration directory:

```text
.backups/nvim-before-rebuild-20261111-015032.tar.gz
.backups/nvim-before-rebuild-20261111-015032.tar.gz.sha256
```

The archive was created before configuration changes. All 72 regular files
were compared byte-for-byte with the originals, including the Git history and
index. It includes the old settings, plugin specifications, lockfile, and staged
and unstaged edits. The archive is owner-readable/writable only; `.backups/`
is excluded from Git.

The snapshot excludes `.backups/` itself and sandbox/tooling directories
`.agents/`, `.codex/`, and `.aws/`. Plugins, Mason tools, caches, editor state,
and credentials outside `~/.config/nvim` were neither archived nor removed.

This is a local backup inside the configuration directory. Copy the archive
and checksum elsewhere before deleting this directory.

## Verify the archive

```sh
cd ~/.config/nvim/.backups
sha256sum -c nvim-before-rebuild-20261111-015032.tar.gz.sha256
```

Expected SHA-256:

```text
68f431a37882102c99eede160fce230f6e41dac890359f48641ca6e60677a6d5
```

## Inspect without replacing the new setup

Extract into a fresh temporary directory, preserving this rebuild:

```sh
restore_dir=$(mktemp -d /tmp/nvim-before-rebuild.XXXXXX)
tar -xzf ~/.config/nvim/.backups/nvim-before-rebuild-20261111-015032.tar.gz -C "$restore_dir"
printf 'Previous configuration extracted to: %s\n' "$restore_dir"
```

The extracted directory includes `.git/`, so its old staged and unstaged
changes can be inspected using `git -C "$restore_dir" status`.

## Restore the old configuration as the active setup

Close Neovim first. These commands preserve the entire rebuild under a new
sibling directory and restore into an empty configuration directory, avoiding
leftover files from the rebuild. Run them in a normal terminal with write
access to `~/.config`:

```sh
cd ~/.config
saved_rebuild=$(mktemp -d "$PWD/nvim-rebuild-saved.XXXXXX")
mv nvim "$saved_rebuild/nvim" && mkdir nvim && \
  tar -xzf "$saved_rebuild/nvim/.backups/nvim-before-rebuild-20261111-015032.tar.gz" -C nvim
printf 'Rebuild and backup preserved at: %s/nvim\n' "$saved_rebuild"
```

Start `nvim` again. The old configuration will use the existing plugin and
tool installations. The archive preserves configuration and pinned versions;
it does not snapshot the external plugin directories themselves.
