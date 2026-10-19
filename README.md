# Dotfiles

Michael Andrews’ personal macOS development configuration, kept in Git so it can be reviewed, backed up, and installed consistently on another machine.

The repository is the source of truth for the configuration. Shell files are stored here without a leading dot, and the `install` zsh script symlinks them into the home directory with their expected dot-prefixed names. Agent instructions and skills share an agent-neutral directory. Editing an installed symlink updates the repository’s source file.

The current setup uses zsh, Apple Silicon Homebrew, Antigen, Oh My Zsh plugins, Powerlevel10k, and GitHub CLI authentication over HTTPS. iTerm2 profiles and portable settings are tracked here, along with a Homebrew package manifest and shared instructions and skills for coding agents.

## What is included

| Repository path | Installed path | Purpose |
| --- | --- | --- |
| `zprofile` | `~/.zprofile` | Initializes Homebrew for login shells and adds JetBrains Toolbox scripts to `PATH`. |
| `zshrc` | `~/.zshrc` | Configures interactive shells, completion caches, custom functions, plugins, and the prompt. |
| `p10k.zsh` | `~/.p10k.zsh` | Stores Powerlevel10k appearance and prompt behavior. |
| `zfunctions/` | `~/.zfunctions` | Contains custom commands implemented as autoloadable zsh functions. |
| `gitconfig` | `~/.gitconfig` | Makes Git use GitHub CLI credentials for GitHub and Gist HTTPS connections. |
| `agents/` | `~/.agents` | Shared global instructions and personal skills, independent of a particular agent. |
| `agents/AGENTS.md` | `~/.codex/AGENTS.md` through `~/.agents/AGENTS.md` | Supplies Codex with the shared global background and working agreements. |
| `agents/skills/maintain-dotfiles/` | `~/.agents/skills/maintain-dotfiles/` | Teaches agents how to maintain this setup, including its Brewfile. |
| `iterm2/com.googlecode.iterm2.plist` | iTerm2 custom settings folder | Preserves profiles, fonts, colors, keyboard mappings, and portable preferences. |
| `Brewfile` | Used by `brew bundle` | Lists intentional Homebrew tools, Codex, and the selected Nerd Font families. |
| `install` | Run from the repository | Creates symlinks, configures the iTerm2 settings folder, and backs up conflicting state. |

`~/.zfunctions` is a symlink to the entire `zfunctions` directory, so newly added functions are automatically part of the repository’s working tree.

## Install

### Prerequisites

The configuration currently assumes macOS with Homebrew installed at `/opt/homebrew`. Git must be available to clone the repository (for example, through the Xcode Command Line Tools or `brew install git`). On another machine, review `zprofile` before installing: its JetBrains Toolbox path currently includes `/Users/Michael` and may need adjustment.

### Clone and link

```zsh
mkdir -p ~/src
git clone https://github.com/michaelajr/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
brew bundle --file=Brewfile
./install --dry-run
./install
exec zsh
```

If the repository is already cloned, start with `cd ~/src/dotfiles`.

The installer links configuration and selects `iterm2/` as iTerm2’s custom settings folder, with changes saved on quit. Quit and reopen iTerm2 to activate the folder. The separate `brew bundle` step installs packages and fonts. The installer does not log in to GitHub. Antigen downloads the configured plugins and Powerlevel10k when the shell first loads them, so first startup requires an internet connection.

The repository can live in another permanent location. The installer derives its source directory from its own path and creates absolute symlinks. If you move the repository, run `./install` again from its new location.

### Installer behavior and backups

- `./install --dry-run` prints the planned changes without modifying files.
- `./install` leaves existing correct symlinks and matching iTerm2 settings-folder preferences alone, so it can be run repeatedly.
- Conflicting files, directories, and different or broken symlinks are moved aside before replacement.
- Backups are kept outside the repository under `~/.local/state/dotfiles/backups/<timestamp>-<process-id>/`, retaining paths such as `.zshrc` and `.codex/AGENTS.md`. Before changing iTerm2’s settings-folder preferences, the installer also exports existing local preferences there as `iterm2-preferences.plist`.
- `./install --help` displays usage information.

Backups are not merged into the repository automatically. To restore one, inspect it first, remove the corresponding installed symlink, and move the backup to its original home-directory location.

## Shell setup

For a login shell, `zprofile` sets up Homebrew and the Toolbox scripts path. Interactive shells then load `zshrc`, which:

1. Loads the Powerlevel10k instant-prompt cache when available.
2. Creates the completion-cache directories needed by Antigen and the kubectl plugin.
3. Adds `~/.zfunctions` to zsh’s function search path and registers its functions for autoloading.
4. Loads Oh My Zsh libraries and plugins through Antigen.
5. Loads the Powerlevel10k theme and the preferences in `~/.p10k.zsh`.
6. Prepends `~/.local/bin` to `PATH` so user-installed commands are available and take precedence over commands in later entries.

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

Choose the terminal font in **iTerm2 → Settings → Profiles → Text**. The Brewfile installs RobotoMono and JetBrains Mono Nerd Font; font binaries stay outside Git. iTerm2 preferences are tracked in `iterm2/`. After running a configuration wizard or another tool that rewrites a dotfile, check `git diff` and confirm that its home-directory symlink is still intact.

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

## Homebrew packages

`Brewfile` records intentionally installed packages and applications managed by Homebrew, rather than every transitive dependency. It includes the shell tools, Git, Codex CLI, and RobotoMono and JetBrains Mono Nerd Font families. Applications installed separately, such as iTerm2 and JetBrains Toolbox, are not currently managed by this manifest.

```zsh
brew bundle --file=Brewfile
brew bundle check --file=Brewfile
```

When adding or removing a persistent Homebrew tool, cask, or font, update the Brewfile in the same change. For example, add `brew "jq"` when intentionally installing jq. Dependencies installed automatically by another package normally do not need separate entries. A temporary experiment does not have to become part of the reproducible setup.

To regenerate a snapshot of this machine’s Homebrew inventory:

```zsh
brew bundle dump --file=Brewfile --force
git diff -- Brewfile
```

Review the diff before keeping a regenerated manifest, especially on another machine. Homebrew commands run manually do not automatically edit this file. The `maintain-dotfiles` skill tells agents assisting with intentional package changes to maintain it as part of the work.

## iTerm2 preferences

`iterm2/com.googlecode.iterm2.plist` stores the portable settings and Default profile, including font choices, colors, and keyboard mappings. The initial export omits installation IDs, window positions, update-check metadata, and `NoSync` runtime state. It does not contain saved sessions, terminal history, or Keychain credentials.

The installer configures iTerm2’s native **General → Settings → Load settings from a custom folder or URL** feature to use this repository’s `iterm2/` directory and save settings changes there on quit. The live plist in `~/Library/Preferences` is not symlinked. Restart iTerm2 once after installation; changes made through its Settings window are saved to the tracked file when iTerm2 quits. Review the resulting Git diff before committing.

If the repository moves, rerun `./install` to update the custom-folder path. Other iTerm2 data remains local.

## Shared agent configuration

```text
agents/
  AGENTS.md
  skills/
    maintain-dotfiles/
      SKILL.md
```

The design keeps personal background, working agreements, and portable skills independent of any one agent. `AGENTS.md` applies broadly; a skill carries instructions for a particular workflow and is loaded when relevant.

The installer creates these links:

```text
~/.agents          → <repository>/agents
~/.codex/AGENTS.md  → ~/.agents/AGENTS.md
```

Codex reads global instructions from `~/.codex/AGENTS.md` and discovers personal skills under `~/.agents/skills/`. Its older `~/.codex/skills/` location and bundled system skills are left in place. The shared `~/.agents/AGENTS.md` is the canonical file, but is not a universally discovered global instruction path: the Codex link makes it available where Codex expects it.

Gemini CLI, Copilot CLI, Cursor, and Junie CLI also document support for the shared skills location. Other agents can be connected as they are adopted: for example, link their expected global instruction file to the shared `AGENTS.md`, and link individual skill folders where required. Claude Code uses `~/.claude/CLAUDE.md` for global instructions and `~/.claude/skills/` for personal skills. Local filesystem links do not automatically supply instructions to cloud-hosted agent sessions.

Each skill has its own folder with `SKILL.md`, YAML frontmatter containing `name` and `description`, and optional scripts or references. Keep the core instructions portable; agent-specific tools and metadata may need adaptation. The `maintain-dotfiles` skill describes this repository’s maintenance workflow and Brewfile policy. Invoke it explicitly in Codex as `$maintain-dotfiles`, or let the agent select it for a relevant task.

The shared `AGENTS.md` includes Michael’s professional background and location intentionally. Keep credentials, agent authentication, chat history, memories, caches, and runtime configuration outside this directory. Project-specific instructions belong in each project’s own `AGENTS.md`, not in the global personal file.

References: [Codex instruction discovery](https://learn.chatgpt.com/docs/agent-configuration/agents-md), [Codex skill discovery](https://learn.chatgpt.com/docs/build-skills), and [iTerm2 custom settings folders](https://iterm2.com/documentation-preferences-general.html).

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

This repository tracks configuration, function source, and shared JetBrains project metadata in `.idea/`. Credentials, private keys, GitHub CLI authentication data, shell history, session state, caches, compiled `.zwc` files, fonts, and application runtime data stay outside it. The `.gitignore` files also exclude common generated files and local editor state.

Review additions before committing: this is a public repository, and the ignore rules do not detect secrets inside configuration files.
