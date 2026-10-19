---
name: maintain-dotfiles
description: Maintain Michael's macOS dotfiles, shell setup, shared agent configuration, and iTerm2 preferences. Also use when assisting with intentional Homebrew tool, cask, or font additions and removals so the Brewfile stays current.
---

# Maintain the dotfiles

## Purpose and layout

The repository is Michael's reviewed source of truth for a reproducible local development setup. It normally lives at `~/src/dotfiles`; if it has moved, resolve the `~/.agents` symlink and use its parent directory to locate it. Read the repository's `README.md`, `install`, and current Git status before changing the setup.

The design favors ordinary files, explicit symlinks, and a small zsh installer:

- Shell files are stored without leading dots: `zprofile`, `zshrc`, `p10k.zsh`, and `gitconfig` link to their usual home-directory paths.
- `zfunctions/` is linked as a whole to `~/.zfunctions`. Each regular file is an autoloadable function body, named after its command, without an outer function declaration or `.zsh` extension. Put explanations in the repository README.
- `agents/` is linked to `~/.agents`, keeping personal instructions and skills independent of a vendor. `~/.codex/AGENTS.md` points to the shared `~/.agents/AGENTS.md`. Add compatibility links for other agents only when they are adopted; check their current discovery rules.
- `iterm2/` is iTerm2's native custom-settings folder. The live `~/Library/Preferences` plist is not symlinked. UI changes are saved to the tracked plist on quit.
- `Brewfile` records the intended Homebrew package set. The installer links configuration and selects the iTerm2 settings folder; package installation is a separate `brew bundle` step.

Keep instructions agent-neutral where possible. Put project-specific guidance in the relevant project's `AGENTS.md`; personal background and broadly applicable working agreements belong in the shared global file. Use one directory with `SKILL.md` per reusable workflow.

## Making configuration changes

Edit the tracked source or its installed symlink. When moving an existing configuration into the repository, preserve its contents, add its installation mapping, and document the purpose and installed location. Keep existing user edits intact, including unrelated staged changes.

Preserve the installer's behavior: validate sources before mutation, support a non-mutating `--dry-run`, leave correct links alone, and back up conflicting files, directories, or broken links outside Git under `~/.local/state/dotfiles/backups/`. Preserve nested paths in backups. Agent authentication, built-in skills, and runtime directories remain managed by their applications.

This is a public repository. Keep credentials, tokens, private keys, shell history, agent conversations and memories, caches, and machine-local Git identity out of it. `~/.gitconfig.local` is intentionally private. Review exports for sensitive values and machine state before tracking them. Michael's professional background in the shared `AGENTS.md` is intentional.

## Keeping the Brewfile current

When helping install or remove a tool, cask, or font intended to remain part of this Mac's development setup, update `Brewfile` in the same task. Use `brew "name"` for formulae and `cask "name"` for casks. Do not list automatically installed dependencies separately unless they are also intentionally used on their own. Temporary experiments need not become part of the manifest.

Prefer a focused edit for a focused package change. For a requested inventory refresh, use `brew bundle dump --file=Brewfile --force` and review its diff; do not blindly replace the intended package set with another machine's inventory. Check consistency with `brew bundle check --file=Brewfile`. Font binaries and package installations stay outside Git.

Manual Homebrew commands do not automatically maintain the file. This skill establishes the maintenance workflow for agents assisting with those changes.

## Verification and handoff

For shell changes, run `zsh -n` and a relevant behavior check. For installer changes, check dry-run, backup preservation, and repeated installation using a disposable home directory or isolated copy before installing into the real home directory. Validate preference-file syntax and inspect the profile values that matter when editing iTerm2 settings.

Update the README when layout, setup, or behavior changes. Review `git diff --check` and the final diff. Explain required shell reloads or application restarts. Commit or push when requested; this skill does not itself authorize publishing changes.
