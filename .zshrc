# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="terminalparty"
ZSH_THEME="drofloh"
#ZSH_THEME_RANDOM_CANDIDATES="terminalparty,drofloh" # ",Ducula,AgnosterZak"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
ZSH_THEME_RANDOM_CANDIDATES="powerline"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    battery
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# 命令高亮
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 命令提示
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.bash_profile
source ~/.bashrc
export PATH="/usr/local/opt/ruby/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ricardo/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ricardo/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ricardo/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ricardo/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
source "/Users/ricardo/anaconda3/etc/profile.d/conda.sh"
[[ -z $TMUX ]] || conda deactivate; conda activate base
# <<< conda initialize <<<

if brew list | grep coreutils > /dev/null ; then
  PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  alias ls='ls -F --show-control-chars --color=auto'
  eval `gdircolors -b $HOME/.dir_colors`
fi


alias sshaws="ssh -i ~/Documents/aws_1.pem ubuntu@aws.sshug.cn"


# powerline
#export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:PATH
#. /Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

export PATH="/usr/local/opt/bc/bin:$PATH"

alias pwc='pwd | xsel -b'
alias pwv='cd `xsel -b`'
alias shotwel='shotwell'
alias sw='shotwell'
alias st='shotwell'
alias cl='clear'
alias countjpg='find -name "*.jpg" | wc -l'
alias countjson='find -name "*.json" | wc -l'


alias sshali="ssh -p 2222 root@ali.sshug.cn"
alias sshwork="ssh ricardo@workmachine"
alias sshworkb="ssh -p 2200 ricardo@sshug.cn"
alias sshs="ssh root@sshug.cn"
alias hpwget="wget -e \"HTTPS_PROXY=http://localhost:1084\" --no-check-certificat"
alias hpcurl="curl -x http://localhost:1084"
