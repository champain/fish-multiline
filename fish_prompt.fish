# name: Multiline
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  set -l show_untracked (git config --bool bash.showUntrackedFiles)
  set untracked ''
  if [ "$theme_display_git_untracked" = 'no' -o "$show_untracked" = 'false' ]
    set untracked '--untracked-files=no'
  end 
  echo (command git status -s --ignore-submodules=dirty $untracked ^/dev/null)
end


# Git stuff
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showcleanstate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'no'
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red
set __fish_git_prompt_color_branch purple
set __fish_git_prompt_showcolorhints 'yes'
# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'



# Git branch name
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function fish_prompt
    and set retc green; or set retc red
    tty|grep -q tty; and set tty tty; or set tty pts

    set_color blue
    if [ $tty = tty ]
        echo -n .-
    else
        echo -n '┌'
    end
    set_color -o blue 
    echo -n [
    if test $USER = root -o $USER = toor
        set_color -o red
    else
        set_color -o white
    end
    echo -n $USER
    set_color -o blue 
    echo -n Ԇ 
    if [ -z "$SSH_CLIENT" ]
        set_color -o white 
    else
        set_color -o cyan
    end
    echo -n (hostname)
    set_color blue 
    echo -n ']'
    set_color normal
    set -l blue (set_color blue)
    set -l red (set_color red)
    set -l white (set_color white)
    if [ (_git_branch_name) ]
        set -l git_branch $white(_git_branch_name)
        set git_info "$blue ($git_branch$blue)"
        
        if [ (_is_git_dirty) ]
            set -l dirty "$red ✗"
            set -l git_branch $red(_git_branch_name)
            set git_info "$blue ($git_branch$blue)$dirty"
        end
        echo $git_info
    else
        echo
    end
    set_color normal 
    for job in (jobs)
        set_color $retc
        if [ $tty = tty ]
            echo -n '; '
        else
            echo -n '│ '
        end
        set_color brown
        echo $job
    end
    set_color blue
    if [ $tty = tty ]
        echo -n "'->"
    else
        echo -n '└⎣'
    end
    set_color -o white
    #echo -n :(prompt_pwd)
    echo -n (pwd|sed "s=$HOME=~=")
    set_color -o blue 
    echo -n '⎤⋟ '
    set_color normal
end
