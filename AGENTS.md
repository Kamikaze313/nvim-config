# Maintaining this Neovim configuration

- Build from scratch, following the user's feature selections.
- Present features one at a time as short benefit-focused pitches for yes/no.
  Install optional features
  after the user selects them; include and explain their required dependencies.
- The user selected lazy.nvim strictly as a plugin manager. Keep the setup
  minimal: no distribution imports, feature bundles, or unsolicited plugins.
  See docs/plugin-manager.md for the selected behavior and directory layout.
- Document every setting inline: what it does and why it exists.
- Document each selected feature's dependencies, commands, shortcuts, automatic
  behavior, configuration location, and disabling instructions.
- For every addition, include a brief usage guide with a practical example,
  including how to open it, use its main controls, and close it when applicable.
- Keep README.md and docs/features.md current with each configuration change.
- Give custom keymaps a `desc` field and document their modes and keys.
- Preserve .backups/ and existing Git history/index. The original snapshot
  includes staged and unstaged user edits; see docs/backup.md.
- Old plugin installations and editor data remain outside this repository.
  Do not clean them as part of rebuilding the configuration.
- Check startup after edits. Choose additional validation based on the feature.
