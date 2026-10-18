# Dotfiles

Personal zsh configuration for macOS with Homebrew, Antigen, Oh My Zsh, and Powerlevel10k.

| Repository file | Installed path | Purpose |
| --- | --- | --- |
| `zprofile` | `~/.zprofile` | Homebrew and JetBrains Toolbox PATH |
| `zshrc` | `~/.zshrc` | Antigen plugins, cache directories, and theme loading |
| `p10k.zsh` | `~/.p10k.zsh` | Prompt preferences, including the alternative Apple icon |
| `zfunctions/` | `~/.zfunctions` | Autoloadable shell commands/functions |
| `gitconfig` | `~/.gitconfig` | GitHub CLI credential helpers |

## Install

Keep this repository at `~/src/dotfiles`, or any permanent location. The installer uses its own location to create absolute symlinks.

```zsh
cd ~/src/dotfiles
./install --dry-run
./install
```

Run `exec zsh` afterward, or open a new terminal window. Re-running the installer leaves correct links alone. Existing files, directories, and different or broken symlinks are preserved under `~/.local/state/dotfiles/backups/<timestamp>-<process-id>/` before replacement. Moving this repository requires running the installer again from its new location.

Edit the repository files or their home-directory symlinks; both refer to the same files. If an application replaces a symlink with a regular file, compare it with the repository copy before running the installer again. Conflicting copies will be backed up, not merged.

## Dependencies

The shell configuration expects Apple Silicon Homebrew at `/opt/homebrew`:

```zsh
brew install antigen kubectl awscli gh
```

Antigen downloads the configured plugins and Powerlevel10k on first use. The theme can be customized with `p10k configure`.

Terminal fonts and iTerm2 preferences are managed separately. Select your preferred Nerd Font in iTerm2. Credentials, private keys, history, caches, compiled zsh files, and app runtime data are intentionally excluded. The generated `.zshrc.zwc` file remains outside this repository.

This is a local Git repository; no remote is configured automatically. Review changes with `git diff` before committing or sharing.

## Custom shell commands

Create one file per function in `~/.zfunctions`, without an extension. The filename is the command name; the file contains the function body, without an outer function definition. No executable bit is needed. Start a new shell to register new commands; existing commands are loaded on first use. To reload an edited function in the current shell, run `unfunction NAME; autoload -Uz NAME`.

For example, a file named `~/.zfunctions/hello` can contain:

```zsh
print -r -- "Hello, ${1:-world}!"
```

## GitHub authentication

In a new shell, run:

```zsh
github-auth
```

This uses `gh auth login --hostname github.com --git-protocol https --web`, then `gh auth setup-git --hostname github.com`. Complete the browser/device-code flow when prompted. The function stops if login fails.

GitHub and GitHub Gist HTTPS operations use the GitHub CLI credential helper. SSH remotes still use SSH authentication; use an HTTPS remote URL to use this helper. Authentication credentials are managed by GitHub CLI and are not stored in this repository. Git author name/email are separate settings.
