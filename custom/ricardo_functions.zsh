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
  sun                $'\u7003' # 
  windy              $'\u7042' #
  litte_rain         $'\u7030' #
  rain               $'\u7031' #
  heavy_rain         $'\u7032' #
  other_rain         $'\u7033'
  thunder            $'\u701f'
  shade              $'\u7043'
  snow               $'\u7040'
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
  local the_time="%{$fg[black]%}[%*]"

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
    # 时间间隔10min获取天气
    # TODO 在text中出现error时重新获取
    # 安装json解析jq
    if [[ ! $(which jq) =~ "bin/jq" ]];then
        apt install jq -y
    fi

    isLoad=0
    if [ ! -f "/tmp/temp" ]; then let isLoad=1; fi 
    # 获取时间间隔，取正
    if [ $isLoad -eq 0 ]; then
        time1=`date +%s`
        time2=$(cat /tmp/temp|awk '{print int($1)}')
        timespan=`expr $time1 - $time2`
        if [ $timespan -gt 600 ]; then
            let isLoad=1
        fi
    fi

    if [ $isLoad -eq 1 ]; then
        echo "load weather - $(date '+%Y-%m-%d %H:%M:%S')" > /tmp/weather_log.log
        localtion="101021200"
        weather_sign_key="f1389a5269a2481489ee834d76a0cfc9"
        local weatherjson=$(curl -s "https://devapi.qweather.com/v7/weather/now?location=${localtion}&key=${weather_sign_key}&gzip=n")
        #备用key，防止一天的请求次数超过了
        code=$(echo $weatherjson|jq ".code")
        if [ ! $code = "200" ]; then
            local weatherjson=$(curl -s "https://devapi.qweather.com/v7/weather/now?location=${localtion}&key=d437cf0c800d4c2abef5174a0bfe029e&gzip=n")
        fi
        local temp=$(echo $weatherjson|jq ".now.temp"|sed 's/\"//g')
        local text=$(echo $weatherjson|jq ".now.text"|sed 's/\"//g')
        echo "$(date '+%s') ${temp} $text" > /tmp/temp
    else
        echo "use old - $(date "+%H:%M:%S")" >> /tmp/weather_log.log
        local temp=$(cat /tmp/temp|awk '{print $2}')
        local text=$(cat /tmp/temp|awk '{print $3}')
    fi
    #text=雷阵雨
    if [ $text = "晴" ];then
        local icon="%{$FG[222]%}${ICONS[sun]}%{$fg[white]%}"
    elif [ $text = '多云' ];then
        local icon="%{$fg[white]%}${ICONS[windy]}%{$fg[white]%}"
    elif [ $text = '大雨' ];then
        local icon="%{$FG[17]%}${ICONS[heavy_rain]}%{$fg[white]%}"
    elif [ $text = '中雨' ];then
        local icon="%{$FG[17]%}${ICONS[rain]}%{$fg[white]%}"
    elif [ $text = '小雨' ];then
        local icon="%{$FG[17]%}${ICONS[litte_rain]}%{$fg[white]%}"
    elif [ $text = '阴' ];then
        local icon="%{$FG[243]%}${ICONS[shade]}%{$fg[white]%}"
    elif [[ $text =~ '雷' ]];then
        local icon="%{$FG[17]%}${ICONS[thunder]}%{$fg[white]%}"
    elif [[ $text =~ '雨' ]];then #包含
        local icon="%{$FG[17]%}${ICONS[other_rain]}%{$fg[white]%}"
    elif [[ $text =~ '雪' ]];then #包含
        local icon="%{$FG[17]%}${ICONS[snow]}%{$fg[white]%}"
    else
        local icon="%{$fg[white]%}${text}%{$fg[white]%}"
        #local icon="%{$fg[red]%}×%{$fg[white]%}"
    fi
    echo "%{$BG[209]%}%{$FG[104]%}$(rprompt_separator) %{$BG[104]%}%{$fg[white]%} $icon $temp℃ %{$reset_color%}"
}
