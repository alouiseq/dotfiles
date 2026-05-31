#!/bin/bash

# Dev Launcher (macOS) - start dev environments using iTerm2 native tabs/panes
# Usage: ./dev-launcher-mac.sh
#
# iTerm2 Session Name/Title Notes:
# - Session names are set via AppleScript `set name to` AFTER a delay, because
#   claude and other processes override the name before the session initializes.
# - Each session must be captured into a variable (e.g., `set webPane to current
#   session of tab`) before splitting or creating new tabs. Using `current session`
#   dynamically resolves to whichever session is active, which changes after splits
#   and new tab creation.
# - iTerm2 Profile > General > Title must be set to "Name" only, otherwise tabs
#   display the running process name (Job) instead of the assigned session name.

# Check for iTerm2
if [[ ! -d "/Applications/iTerm.app" ]]; then
  echo "Error: iTerm2 is not installed. Install it from https://iterm2.com"
  exit 1
fi

PROJECTS=(
  "tenxrep"
  "school-comms"
  "main-site"
  "exectheedge-journal"
  "multi-ppo"
)

# Shell snippet: if current branch is `main`, pull; otherwise no-op.
# Safe in non-repo dirs (git returns empty, grep fails, no-op). `|| true` swallows
# pull errors / git-lock conflicts so the rest of the chain still runs.
PULL_CHECK='{ git branch --show-current 2>/dev/null | grep -qx main && git pull || true; }'

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

echo -e "${BOLD}${CYAN}=== Dev Launcher (macOS) ===${RESET}\n"

# Track selections (0 = unselected, 1 = selected)
declare -a selected
for i in "${!PROJECTS[@]}"; do
  selected[$i]=0
done

# --help / -h: print usage and the project list, then exit
for arg in "$@"; do
  case "$arg" in
    -h|--help|help)
      echo -e "${BOLD}Usage:${RESET} rp [numbers... | a | -h]"
      echo ""
      echo -e "${BOLD}Examples:${RESET}"
      echo "  rp           # interactive menu"
      echo "  rp 1 3       # launch projects 1 and 3"
      echo "  rp a         # launch all projects"
      echo ""
      echo -e "${BOLD}Projects:${RESET}"
      for i in "${!PROJECTS[@]}"; do
        echo "  $((i+1)). ${PROJECTS[$i]}"
      done
      exit 0
      ;;
  esac
done

# Non-interactive mode: arguments passed (e.g. `rp 1 3 5` or `rp a`)
if [[ $# -gt 0 ]]; then
  for arg in "$@"; do
    case "$arg" in
      a|A|all)
        for i in "${!PROJECTS[@]}"; do
          selected[$i]=1
        done
        ;;
      *)
        if [[ "$arg" =~ ^[0-9]+$ ]] && (( arg >= 1 && arg <= ${#PROJECTS[@]} )); then
          selected[$((arg - 1))]=1
        else
          echo -e "${RED}Invalid argument:${RESET} $arg (expected 1-${#PROJECTS[@]} or 'a')"
          exit 1
        fi
        ;;
    esac
  done
else
  echo -e "Select projects to start (toggle with number, ${GREEN}Enter${RESET} to launch):\n"

  print_menu() {
    for i in "${!PROJECTS[@]}"; do
      if [[ ${selected[$i]} -eq 1 ]]; then
        echo -e "  ${GREEN}[x]${RESET} $((i+1)). ${BOLD}${PROJECTS[$i]}${RESET}"
      else
        echo -e "  [ ] $((i+1)). ${PROJECTS[$i]}"
      fi
    done
    echo ""
    echo -e "  ${YELLOW}a${RESET}) Select all  ${YELLOW}n${RESET}) Select none  ${GREEN}Enter${RESET}) Launch selected  ${RED}q${RESET}) Quit"
  }

  while true; do
    print_menu
    echo ""
    read -rp "Choice: " choice

    # Move cursor up to redraw menu cleanly
    lines=$((${#PROJECTS[@]} + 4))
    printf "\033[%dA\033[J" "$lines"

    case "$choice" in
      q|Q)
        echo "Cancelled."
        exit 0
        ;;
      a|A)
        for i in "${!PROJECTS[@]}"; do
          selected[$i]=1
        done
        ;;
      n|N)
        for i in "${!PROJECTS[@]}"; do
          selected[$i]=0
        done
        ;;
      "")
        break
        ;;
      *)
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#PROJECTS[@]} )); then
          idx=$((choice - 1))
          if [[ ${selected[$idx]} -eq 0 ]]; then
            selected[$idx]=1
          else
            selected[$idx]=0
          fi
        fi
        ;;
    esac
  done
fi

# Collect selected project names
selected_projects=()
for i in "${!PROJECTS[@]}"; do
  if [[ ${selected[$i]} -eq 1 ]]; then
    selected_projects+=("${PROJECTS[$i]}")
  fi
done

if [[ ${#selected_projects[@]} -eq 0 ]]; then
  echo -e "${YELLOW}No projects selected.${RESET}"
  exit 0
fi

# Pre-flight: verify required directories exist for each selected project.
# Missing dirs would otherwise cause `cd` to fail silently inside iTerm panes.
required_dirs_for() {
  case "$1" in
    tenxrep)             echo "$HOME/code/tenxrep/tenxrep-web" "$HOME/code/tenxrep/tenxrep-api" ;;
    school-comms)        echo "$HOME/code/school-comms" ;;
    main-site)           echo "$HOME/code/main-site" ;;
    exectheedge-journal) echo "$HOME/code/exectheedge-journal" ;;
    multi-ppo)           echo "$HOME/code/multiview-indicator/multi-ppo" ;;
  esac
}

missing=()
for project in "${selected_projects[@]}"; do
  for dir in $(required_dirs_for "$project"); do
    if [[ ! -d "$dir" ]]; then
      missing+=("$project: $dir")
    fi
  done
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo -e "${RED}Missing directories:${RESET}"
  for entry in "${missing[@]}"; do
    echo -e "  ${RED}-${RESET} $entry"
  done
  exit 1
fi

# Build AppleScript to launch projects in iTerm2
applescript='
tell application "iTerm2"
  activate
  set mainWindow to (create window with default profile)
  tell mainWindow
'

first_project=true

for project in "${selected_projects[@]}"; do
  if $first_project; then
    # Use the first tab of the new window
    tab_ref="(current tab)"
    first_project=false
  else
    # Create a new tab for subsequent projects
    applescript+='
    set newTab to (create tab with default profile)
'
    tab_ref="newTab"
  fi

  case "$project" in
    tenxrep)
      applescript+="
    -- tenxrep: dev tab (web | api)
    set webPane to current session of $tab_ref
    tell webPane
      write text \"cd $HOME/code/tenxrep/tenxrep-web && $PULL_CHECK && nvm use && npm run dev\"
      set apiPane to (split vertically with default profile)
      tell apiPane
        write text \"cd $HOME/code/tenxrep/tenxrep-api && $PULL_CHECK && source venv/bin/activate && python --version && python run.py\"
      end tell
    end tell
    -- tenxrep: claude tab (dir top 30%, claude bottom 70%; claude pulls if on main)
    set trClaudeTab to (create tab with default profile)
    set trClaudeDirSession to current session of trClaudeTab
    tell trClaudeDirSession
      write text \"cd $HOME/code/tenxrep\"
      set trClaudeOrigRows to rows
      set trClaudeSession to (split horizontally with default profile)
    end tell
    set rows of trClaudeDirSession to (trClaudeOrigRows * 30) div 100
    tell trClaudeSession
      write text \"cd $HOME/code/tenxrep && $PULL_CHECK && claude\"
    end tell
    -- tenxrep: exercises tab (dir top 30%, claude bottom 70%)
    set trExercisesTab to (create tab with default profile)
    set trExercisesDirSession to current session of trExercisesTab
    tell trExercisesDirSession
      write text \"cd $HOME/code/tenxrep\"
      set trExercisesOrigRows to rows
      set trExercisesSession to (split horizontally with default profile)
    end tell
    set rows of trExercisesDirSession to (trExercisesOrigRows * 30) div 100
    tell trExercisesSession
      write text \"cd $HOME/code/tenxrep && claude\"
    end tell
    -- tenxrep: social-content tab (dir top 30%, claude bottom 70%)
    set trSocialTab to (create tab with default profile)
    set trSocialDirSession to current session of trSocialTab
    tell trSocialDirSession
      write text \"cd $HOME/code/tenxrep\"
      set trSocialOrigRows to rows
      set trSocialSession to (split horizontally with default profile)
    end tell
    set rows of trSocialDirSession to (trSocialOrigRows * 30) div 100
    tell trSocialSession
      write text \"cd $HOME/code/tenxrep && claude\"
    end tell
    delay 1
    tell webPane
      set name to \"tenxrep-web\"
    end tell
    tell apiPane
      set name to \"tenxrep-api\"
    end tell
    tell trClaudeDirSession
      set name to \"tenxrep-dir\"
    end tell
    tell trClaudeSession
      set name to \"tenxrep\"
    end tell
    tell trExercisesDirSession
      set name to \"exercises-dir\"
    end tell
    tell trExercisesSession
      set name to \"exercises\"
    end tell
    tell trSocialDirSession
      set name to \"social-content-dir\"
    end tell
    tell trSocialSession
      set name to \"social-content\"
    end tell
"
      ;;
    school-comms)
      applescript+="
    -- school-comms: claude tab (dir top 30%, claude bottom 70%)
    set scDirSession to current session of $tab_ref
    tell scDirSession
      write text \"cd $HOME/code/school-comms\"
      set scOrigRows to rows
      set scSession to (split horizontally with default profile)
    end tell
    set rows of scDirSession to (scOrigRows * 30) div 100
    tell scSession
      write text \"cd $HOME/code/school-comms && $PULL_CHECK && source venv/bin/activate && claude\"
    end tell
    delay 1
    tell scDirSession
      set name to \"school-comms - dir\"
    end tell
    tell scSession
      set name to \"school-comms - claude\"
    end tell
"
      ;;
    main-site)
      applescript+="
    -- main-site: dev tab
    set msDevSession to current session of $tab_ref
    tell msDevSession
      write text \"cd $HOME/code/main-site && $PULL_CHECK && yarn install && yarn start\"
    end tell
    -- main-site: claude tab (dir top 30%, claude bottom 70%)
    set msClaudeTab to (create tab with default profile)
    set msDirSession to current session of msClaudeTab
    tell msDirSession
      write text \"cd $HOME/code/main-site\"
      set msOrigRows to rows
      set msClaudeSession to (split horizontally with default profile)
    end tell
    set rows of msDirSession to (msOrigRows * 30) div 100
    tell msClaudeSession
      write text \"cd $HOME/code/main-site && claude\"
    end tell
    delay 1
    tell msDevSession
      set name to \"main-site - dev\"
    end tell
    tell msDirSession
      set name to \"main-site - dir\"
    end tell
    tell msClaudeSession
      set name to \"main-site - claude\"
    end tell
"
      ;;
    exectheedge-journal)
      applescript+="
    -- exectheedge-journal: dev tab (server top, dir bottom)
    set ejServerSession to current session of $tab_ref
    tell ejServerSession
      write text \"cd $HOME/code/exectheedge-journal && $PULL_CHECK && npm run dev\"
      set ejDirPane to (split horizontally with default profile)
      tell ejDirPane
        write text \"cd $HOME/code/exectheedge-journal\"
      end tell
    end tell
    -- exectheedge-journal: claude tab (dir top 30%, claude bottom 70%)
    set ejClaudeTab to (create tab with default profile)
    set ejDirSession to current session of ejClaudeTab
    tell ejDirSession
      write text \"cd $HOME/code/exectheedge-journal\"
      set ejOrigRows to rows
      set ejClaudeSession to (split horizontally with default profile)
    end tell
    set rows of ejDirSession to (ejOrigRows * 30) div 100
    tell ejClaudeSession
      write text \"cd $HOME/code/exectheedge-journal && claude\"
    end tell
    delay 1
    tell ejServerSession
      set name to \"exectheedge-server\"
    end tell
    tell ejDirPane
      set name to \"exectheedge-dir\"
    end tell
    tell ejDirSession
      set name to \"exectheedge-claude-dir\"
    end tell
    tell ejClaudeSession
      set name to \"exectheedge\"
    end tell
"
      ;;
    multi-ppo)
      applescript+="
    -- multi-ppo: claude tab (dir top 30%, claude bottom 70%)
    set mpDirSession to current session of $tab_ref
    tell mpDirSession
      write text \"cd $HOME/code/multiview-indicator/multi-ppo\"
      set mpOrigRows to rows
      set mpSession to (split horizontally with default profile)
    end tell
    set rows of mpDirSession to (mpOrigRows * 30) div 100
    tell mpSession
      write text \"cd $HOME/code/multiview-indicator/multi-ppo && $PULL_CHECK && claude\"
    end tell
    delay 1
    tell mpDirSession
      set name to \"multi-ppo-dir\"
    end tell
    tell mpSession
      set name to \"multi-ppo\"
    end tell
"
      ;;
  esac
done

applescript+='
    -- Select the first tab
    select first tab
  end tell
end tell
'

echo -e "${GREEN}[+] Launching ${#selected_projects[@]} project(s) in iTerm2...${RESET}"
osascript_err=$(osascript -e "$applescript" 2>&1 >/dev/null)
osascript_status=$?

if [[ $osascript_status -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}Launched ${#selected_projects[@]} project(s) in iTerm2.${RESET}"
else
  echo -e "${RED}Failed to launch iTerm2. Make sure iTerm2 is running or can be started.${RESET}"
  if [[ -n "$osascript_err" ]]; then
    echo -e "${RED}osascript error:${RESET} $osascript_err"
  fi
  exit 1
fi
