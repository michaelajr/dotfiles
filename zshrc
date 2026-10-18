# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ADOTDIR="$HOME/.cache/antigen"
export ANTIGEN_COMPDUMP="$HOME/.cache/zsh/zcompdump"
mkdir -p "$HOME/.cache/zsh"
mkdir -p "$ADOTDIR/bundles/robbyrussell/oh-my-zsh/cache/completions"

# Register one autoloadable function per file in ~/.zfunctions.
if [[ -d "$HOME/.zfunctions" ]]; then
  typeset -gU fpath
  fpath=("$HOME/.zfunctions" $fpath)
  () {
    local function_file
    for function_file in "$HOME"/.zfunctions/*(N-.); do
      autoload -Uz -- "${function_file:t}"
    done
  }
fi

source /opt/homebrew/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle command-not-found
antigen bundle kubectl
antigen bundle aws
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme romkatv/powerlevel10k
antigen apply

# Load your Powerlevel10k preferences after running p10k configure.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
