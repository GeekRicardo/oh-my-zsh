###############################################################
# drofloh oh-my-zsh theme functions
# https://github.com/drofloh/oh-my-zsh-custom
################################################################

typeset -AHg ICONS

ICONS=(
  # Prompt separators
  flame_right        $'\ue0c0' # 
  flame_left         $'\ue0c2' # 
  terminal           $'\uf120' # 

  # OS logos
  apple_logo         $'\uf302' # 

  # directory icon
  folder             $'\ufc6e' # ﱮ

  # battery usage
  battery_full       $'\uf578' # 
  battery_80         $'\uf580' # 
  battery_60         $'\uf57e' # 
  battery_40         $'\uf57c' # 
  battery_20         $'\uf57a' # 
  battery_empty      $'\uf58d' # 
  battery_charging   $'\uf0e7' # 
  battery_plugged_in $'\uf583' # 

  # time / clock icon
  time               $'\uf49b' # 

  # ruby icon
  ruby               $'\ue21e' #  

  # git status icons
  git_branch         $'\ue0a0' # 
  git_added          $'\uf457' # 
  git_modified       $'\uf459' # 
  git_deleted        $'\uf458' # 
  git_renamed        $'\uf45a' # 
  git_unmerged       $'\ue727' # 
  git_untracked      $'\uf128' # 
  git_ahead          $'\uf061' # 
  git_behind         $'\uf060' # 
  git_remote_exists  $'\ufadf' # 﫟
  git_remote_missing $'\uf658' # 

  # weather icons
  sun                $'\ue214' # 
  windy              $'\ue21d' #
  rain               $'\ue239' #
  left_point         $'\ue0c3' #
)

function prompt_separator() {
  echo $ICONS[flame_right]
}

function rprompt_separator() {
  echo $ICONS[flame_left]
}

function prompt_start() {
  local bg_col=%{$BG[104]%}
  
  local cpu_used=$(ps -A -o %cpu | awk '{s+=$1} END {print s "%"}')
  local ret_status="%(?:%{$fg[green]%} $ICONS[apple_logo] :%{$fg[red]%} $ICONS[apple_logo] )${reset_color}"
  echo "${bg_col}${ret_status}"
}

function prompt_dir() {
  #local bg_col=%{$BG[240]%}
  local bg_col=%{$BG[209]%}
  local fg_col=%{$FG[104]%}
  local dir_icon="%{$fg[blue]%}  $ICONS[folder] "
  local directory="%{$fg[white]%}%~"

  echo "${bg_col}${fg_col}$(prompt_separator)${dir_icon}${directory}"
}

function prompt_git () {

  local bg_col=$BG[138]
  local fg_col=$FG[209]

  local prompt_git_start="%{$fg_col%}$(prompt_separator)"
  local prompt_git_end="%{$reset_color%}%{$FG[138]%}$(prompt_separator)"
  # https://stackoverflow.com/questions/2180270/check-if-current-directory-is-a-git-repository
  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    echo "%{$bg_col%}${prompt_git_start} %{$fg[blue]%} $(parse_git_dirty) %{$fg[17]%}$(git_current_branch)$(git_prompt_status)$(git_remote_status)$(git_prompt_remote)${prompt_git_end}"
  else
    echo "%{$reset_color%}%{$prompt_git_start%}"
  fi
}

function prompt_battery() {
  if [[ "$OSTYPE" = darwin* ]]; then
    battery_perc=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
  else
    battery_perc=$(battery_pct)
  fi

  if [[ $battery_perc -gt 90 ]]; then
    icon=$ICONS[battery_full]
    batt_col=$fg[green]
  elif [[ $battery_perc -gt 70 ]]; then
    icon=$ICONS[battery_80]
    batt_col=$fg[green]
  elif [[ $battery_perc -gt 50 ]]; then
    icon=$ICONS[battery_60]
    batt_col=$fg[green]
  elif [[ $battery_perc -gt 30 ]]; then
    icon=$ICONS[battery_40]
    batt_col=$fg[yellow]
  elif [[ $battery_perc -gt 10 ]]; then
    icon=$ICONS[battery_20]
    batt_col=$fg[yellow]
  else
    icon=$ICONS[battery_empty]
    batt_col=$fg[red]
  fi

  if $(battery_is_charging) ; then
    power_icon="%{$fg[yellow]%}${ICONS[battery_charging]}"
#  elif $(plugged_in) ; then
    #power_icon=''
    #icon=$ICONS[battery_plugged_in]
#    batt_col=$fg[green]
  fi
  echo "%{$FG[209]%}$(rprompt_separator) %{$BG[209]%} %{$batt_col%}${icon}${power_icon} %{$fg[black]%}${battery_perc}%% %{$reset_color%}"
}

function prompt_time() {
  local time_icon="%{$fg[cyan]%}${ICONS[time]}"
  local time_icon="%{$fg[black]%}${ICONS[time]}"
  local the_time="%{$fg[black]%}[%T]"

  echo "%{$FG[223]%}$(rprompt_separator) %{$BG[223]%} %{$fg[black]%}${time_icon} ${the_time}"
}

function prompt_ruby_rbenv() {
  local ruby_icon="%{$fg[red]%}${ICONS[ruby]}"
  if [ -f .ruby-version ] ; then
    local version="%{$fg[white]%}$(cat .ruby-version)"
    echo "%{$FG[248]%}$(rprompt_separator) %{$BG[248]%} ${ruby_icon} ${version}"
  fi
}

function prompt_weather(){
    # TODO 时间间隔15min获取天气
    old_time=$(cat /tmp/temp|awk '{print int($1)}')
    if [[ ! -f "/tmp/temp" ]] || [[ `expr $(date "+%M"|awk '{print int($0)}') - $old_time` -gt 10 ]]; then
    #if 1 ;then
        echo "load weather - $(date '+%Y-%m-%d %H:%M:%S')" > /tmp/weather_log.log
        localtion="101021200"
        local weatherjson=$(curl -s "https://devapi.qweather.com/v7/weather/now?location=${localtion}&key=f1389a5269a2481489ee834d76a0cfc9&gzip=n")
        code=$(echo $weatherjson|python3 -c "import sys,json;a=json.load(sys.stdin);print((a['code']))")
        if [ ! $code = "200" ]; then
            local weatherjson=$(curl -s "https://devapi.qweather.com/v7/weather/now?location=${localtion}&key=d437cf0c800d4c2abef5174a0bfe029e&gzip=n")
        fi
        local temp=$(echo $weatherjson|python3 -c "import sys,json;a=json.load(sys.stdin);print((a['now']['temp']) if a['code']=='200' else '')")
        local text=$(echo $weatherjson|python3 -c "import sys,json;a=json.load(sys.stdin);print((a['now']['text']) if a['code']=='200' else '')")
        echo "$(date '+%M') ${temp}" > /tmp/temp
        echo $text > /tmp/text
    else
        echo "use old"> /tmp/weather_log.log
        local temp=$(cat /tmp/temp|awk '{print $2}')
        local text=$(cat /tmp/text)
    fi
    #text=中雨
    if [ $text = "晴" ];then
        local icon="%{$FG[222]%}${ICONS[sun]}%{$fg[white]%}"
    elif [ $text = '多云' ];then
        local icon="%{$fg[white]%}${ICONS[windy]}%{$fg[white]%}"
    elif [ $text = '大雨' ];then
        local icon="%{$FG[17]%}${ICONS[rain]} ${ICONS[rain]} ${ICONS[rain]}%{$fg[white]%}"
    elif [ $text = '中雨' ];then
        local icon="%{$FG[17]%}${ICONS[rain]} ${ICONS[rain]}%{$fg[white]%}"
    elif [[ $text =~ '雨' ]];then #包含
        local icon="%{$FG[17]%}${ICONS[rain]}%{$fg[white]%}"
    fi
    echo "%{$BG[209]%}%{$FG[104]%}$(rprompt_separator) %{$BG[104]%}%{$fg[white]%} $icon $temp℃ %{$reset_color%}"
}
