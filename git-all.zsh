 #!/bin/zsh
# Run git commands on all git repos in the current directory.
# Pete Adriano DeBiase 2020/09/29

# TODO: For git status, only show repos that have changes, and always use git status -s

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Initialization
# └─────────────────────────────────────────────────────────────────────────────
autoload colors && colors
alias -g git='git.exe'

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Functions
# └─────────────────────────────────────────────────────────────────────────────
# Inspired by: https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html
git_info() {
  local GIT_LOCATION=$(git -C $1 rev-parse --abbrev-ref HEAD)
  local GIT_TAGS=$(git -C $1 tag -l --sort=-version:refname --points-at HEAD | xargs | sed -e 's/ /|/g')

  local PREFIX="$fg[green][$reset_color"
  local SUFFIX="$fg[green]]$reset_color"
  local AHEAD="$fg[cyan]NUM↑$reset_color"
  local BEHIND="$fg[yellow]NUM↓$reset_color"
  local MERGING="$fg[magenta]⚡︎$reset_color"
  local UNTRACKED="$fg[cyan]●$reset_color"
  local MODIFIED="$fg[yellow]●$reset_color"
  local STAGED="$fg[green]●$reset_color"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git -C $1 log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git -C $1 log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git -C $1 rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git -C $1 ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git -C $1 diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git -C $1 diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  [[ ${#FLAGS[@]} -ne 0 ]] || [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO=( "$PREFIX${(j::)FLAGS}${(j::)DIVERGENCES}$SUFFIX" )
  [[ ${#FLAGS[@]} -ne 0 ]] && [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO=( "$PREFIX${(j::)FLAGS} ${(j::)DIVERGENCES}$SUFFIX" )
  if [ "$GIT_TAGS" != "" ]; then
    GIT_INFO+=( "$fg[black][$GIT_LOCATION]($GIT_TAGS)$fg[green]" )
  else
    GIT_INFO+=( "$fg[black][$GIT_LOCATION]$fg[green]" )
  fi
  echo "${(j::)GIT_INFO}"
}

# Historical R&D
# search_depth=10
# git_repos=$(find . -maxdepth $search_depth -name .git -type d | rev | cut -c 6- | rev)
# git_repos=(${(f)git_repos})

# echo "Running 'git "$@"' on ${#git_repos[@]} repos in: ${PWD}\n"

# for repo in $git_repos; do
#   echo git.exe -C $repo "$@" &
# done


# ┌─────────────────────────────────────────────────────────────────────────────
# │ Da Script
# └─────────────────────────────────────────────────────────────────────────────
git_command=$1

search_depth=10
git_repos=$(find . -maxdepth $search_depth -name .git -type d | rev | cut -c 6- | rev)
git_repos=(${(f)git_repos}) # Split plaintext list of found repos on newlines to create a proper array

echo "\nRunning 'git "$@"' on ${#git_repos[@]} repos in: ${PWD}\n"
echo $(date)

i=0
for repo in $git_repos; do
  case $git_command in
    fetch|pull|push) # Run expensive git operations in the background (in parallel)
      git -C $repo "$@" &
      ;;
    count) # Count number of commits for specified authors in each repo
      echo $repo
      author_regex=$2
      filename=ga_count_"$(basename $PWD)"_"$2"_"$(date +%F)".txt
      echo $repo >> $filename
      git -C $repo log --all --date=short --pretty=format:%ad --author=$author_regex >> $filename
      echo "\n" >> $filename
      ;;
    *) # Run all other git operations in the foreground
      git_output=$(git -C $repo "$@" 2>&1)
      git_status=$(git_info $repo)
      repo_directory_length=${#repo}
      spacer_length=$(( 100 - $repo_directory_length - 22 ))
      spacer=$(printf "%0.s " $(seq 1 $spacer_length))
      heading="$fg[black][$i]$fg[green] $repo $spacer $git_status"

      printf '%s\n' "$fg[green]┌───────────────────────────────────────────────────────────────────────────────────────────────────" \
                              "│ $heading " \
                              "└───────────────────────────────────────────────────────────────────────────────────────────────────$reset_color"
      echo "$git_output\n"
      ;;
  esac
  ((i++))
done

wait && echo
