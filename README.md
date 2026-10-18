# Dotfiles

Michael Andrews’ personal macOS shell configuration, kept in Git so it can be reviewed, backed up, and installed consistently on another machine.

The repository is the source of truth for the configuration. Files are stored here without a leading dot, and the `install` zsh script symlinks them into the home directory with their expected dot-prefixed names. Editing either path updates the same file.

The current setup uses zsh, Apple Silicon Homebrew, Antigen, Oh My Zsh plugins, Powerlevel10k, and GitHub CLI authentication over HTTPS. iTerm2 is the terminal used with this configuration; its application settings are managed separately.

## What is included

| Repository path | Installed path | Purpose |
| --- | --- | --- |
| `zprofile` | `~/.zprofile` | Initializes Homebrew for login shells and adds JetBrains Toolbox scripts to `PATH`. |
| `zshrc` | `~/.zshrc` | Configures interactive shells, completion caches, custom functions, plugins, and the prompt. |
| `p10k.zsh` | `~/.p10k.zsh` | Stores Powerlevel10k appearance and prompt behavior. |
| `zfunctions/` | `~/.zfunctions` | Contains custom commands implemented as autoloadable zsh functions. |
| `gitconfig` | `~/.gitconfig` | Makes Git use GitHub CLI credentials for GitHub and Gist HTTPS connections. |
| `install` | Run from the repository | Creates the symlinks and backs up conflicting files or directories. |

`~/.zfunctions` is a symlink to the entire `zfunctions` directory, so newly added functions are automatically part of the repository’s working tree.

## Install

### Prerequisites

The configuration currently assumes macOS with Homebrew installed at `/opt/homebrew`. Install the shell tools with:

```zsh
brew install antigen kubectl awscli gh
```

Git must also be available to clone the repository. On another machine, review `zprofile` before installing: its JetBrains Toolbox path currently includes `/Users/Michael` and may need adjustment.

### Clone and link

```zsh
mkdir -p ~/src
git clone https://github.com/michaelajr/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
./install --dry-run
./install
exec zsh
```

If the repository is already cloned, start with `cd ~/src/dotfiles`.

The installer creates symlinks only. It does not install Homebrew packages, fonts, or iTerm2 preferences, and it does not log in to GitHub. Antigen downloads the configured plugins and Powerlevel10k when the shell first loads them, so first startup requires an internet connection.

The repository can live in another permanent location. The installer derives its source directory from its own path and creates absolute symlinks. If you move the repository, run `./install` again from its new location.

### Installer behavior and backups

- `./install --dry-run` prints the planned changes without modifying files.
- `./install` leaves existing correct symlinks alone, so it can be run repeatedly.
- Conflicting files, directories, and different or broken symlinks are moved aside before replacement.
- Backups are kept outside the repository under `~/.local/state/dotfiles/backups/<timestamp>-<process-id>/`, retaining their original dot-prefixed names.
- `./install --help` displays usage information.

Backups are not merged into the repository automatically. To restore one, inspect it first, remove the corresponding installed symlink, and move the backup to its original home-directory location.

## Shell setup

For a login shell, `zprofile` sets up Homebrew and the Toolbox scripts path. Interactive shells then load `zshrc`, which:

1. Loads the Powerlevel10k instant-prompt cache when available.
2. Creates the completion-cache directories needed by Antigen and the kubectl plugin.
3. Adds `~/.zfunctions` to zsh’s function search path and registers its functions for autoloading.
4. Loads Oh My Zsh libraries and plugins through Antigen.
5. Loads the Powerlevel10k theme and the preferences in `~/.p10k.zsh`.

The configured plugins are:

| Plugin | Purpose |
| --- | --- |
| `git` | Git aliases and shell helpers. |
| `command-not-found` | Integrates available command-not-found handlers. |
| `kubectl` | Kubernetes aliases and completion support. |
| `aws` | AWS CLI helpers and completion support. |
| `zsh-autosuggestions` | Suggests commands while typing. |
| `zsh-syntax-highlighting` | Highlights shell command syntax. |

Antigen’s downloaded bundles and generated completion files live under `~/.cache`, outside this repository.

## Prompt and fonts

Powerlevel10k preferences are tracked in `p10k.zsh`. To run its interactive configuration wizard:

```zsh
p10k configure
```

To apply manual edits to the prompt preferences in the current shell:

```zsh
source ~/.p10k.zsh
```

The current configuration uses the alternative Apple glyph `U+F302`, which was chosen for its appearance alongside the Home icon with RobotoMono Nerd Font. Icon appearance depends on the selected font and terminal settings.

Choose the terminal font in **iTerm2 → Settings → Profiles → Text**. Font files and iTerm2 preferences are not installed by this repository. After running a configuration wizard or another tool that rewrites a dotfile, check `git diff` and confirm that its home-directory symlink is still intact.

## Custom commands in ~/.zfunctions

Create one file per command, using the command name as its filename, without a `.zsh` extension. The file contains the function body; an outer function declaration and executable permissions are unnecessary.

For example, create `~/.zfunctions/hello` containing:

```zsh
print -r -- "Hello, ${1:-world}!"
```

Open a new shell, then run:

```zsh
hello
hello Michael
```

At startup, `zshrc` puts `~/.zfunctions` first in `fpath`, zsh’s function search path. It collects the function names from `fpath[1]` and registers them together with one `autoload -Uz` call:

```zsh
local -a function_names=("${fpath[1]}"/*(N-.:t))
if (( ${#function_names} )); then
  autoload -Uz -- "${function_names[@]}"
fi
```

This snippet runs inside an anonymous function so the temporary array stays local. `N` allows an empty directory, `-.` selects regular files while following symlinks, and `:t` keeps only filenames. The count check avoids invoking `autoload` without arguments when the directory is empty. `fpath` supplies search locations; `autoload` registers the command names. Function bodies are loaded on first use.

To register a new command immediately in the current shell:

```zsh
autoload -Uz hello
```

To reload a function whose body has already been loaded:

```zsh
unfunction hello
autoload -Uz hello
```

Use this directory for function files only: every regular file in it is registered as a command. Add documentation to the repository README instead of placing it in `zfunctions`.

## GitHub authentication

Run the included command from an interactive shell:

```zsh
github-auth
```

It runs these commands in order:

```zsh
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git --hostname github.com
```

Complete the browser/device-code flow when prompted. If login fails, the function stops before running Git setup.

Git uses the GitHub CLI credential helper for `https://github.com` and `https://gist.github.com`. The empty helper entry in each section resets inherited helpers for that host before selecting `gh`. Other Git hosts retain their existing credential configuration. The configured helper path assumes Homebrew’s `gh` at `/opt/homebrew/bin/gh`.

Use HTTPS remote URLs, such as `https://github.com/michaelajr/dotfiles.git`, to use this authentication setup. SSH remotes authenticate with SSH keys instead. Git author name and email are separate from authentication. The tracked `gitconfig` includes `~/.gitconfig.local` for machine-local identity and preferences; that file is not installed or tracked by this repository. Git treats its included settings as global configuration. On a new machine, set your identity with:

```zsh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

Your author name and email still appear in the metadata of commits you publish.

GitHub CLI manages login credentials outside the repository. A raw-file download with a tool such as `curl` does not consult Git’s credential helper; use `gh api` for authenticated GitHub API requests.

To check the current login:

```zsh
gh auth status --hostname github.com
```

## Maintaining the repository

Changes made through the installed symlinks are already changes in this repository:

```zsh
cd ~/src/dotfiles
git status
git diff
git add <files>
git commit -m "Describe the configuration change"
git push
```

To obtain updates from GitHub when the working tree is clean:

```zsh
cd ~/src/dotfiles
git pull --ff-only
./install
exec zsh
```

If a tool replaces a home-directory symlink with a regular file, compare that file with the repository version before reinstalling. The installer preserves the conflicting copy in its backup directory but does not merge its changes.

## What stays outside Git

This repository tracks configuration and function source. Credentials, private keys, GitHub CLI authentication data, shell history, session state, caches, compiled `.zwc` files, fonts, and application runtime data stay outside it. The `.gitignore` also excludes common generated files and editor artifacts.

Review additions before committing: this is a public repository, and the ignore rules do not detect secrets inside configuration files.
