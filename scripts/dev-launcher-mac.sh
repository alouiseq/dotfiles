#!/bin/bash

# Dev Launcher (macOS) - start dev environments using iTerm2 native tabs/panes
# Usage: ./dev-launcher-mac.sh

# Check for iTerm2
if [[ ! -d "/Applications/iTerm.app" ]]; then
  echo "Error: iTerm2 is not installed. Install it from https://iterm2.com"
  exit 1
fi

PROJECTS=(
  "tenxrep"
  "school-comms"
  "main-site"
)

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

echo -e "${BOLD}${CYAN}=== Dev Launcher (macOS) ===${RESET}\n"
echo -e "Select projects to start (toggle with number, ${GREEN}Enter${RESET} to launch):\n"

# Track selections (0 = unselected, 1 = selected)
declare -a selected
for i in "${!PROJECTS[@]}"; do
  selected[$i]=0
done

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
    -- tenxrep: dev tab with split panes
    set webPane to current session of $tab_ref
    tell webPane
      write text \"cd $HOME/code/tenxrep/tenxrep-web && nvm use && npm run dev\"
      set apiPane to (split vertically with default profile)
      tell apiPane
        write text \"cd $HOME/code/tenxrep/tenxrep-api && source venv/bin/activate && python --version && python run.py\"
      end tell
    end tell
    -- tenxrep: claude tab
    set trClaudeTab to (create tab with default profile)
    set trClaudeSession to current session of trClaudeTab
    tell trClaudeSession
      write text \"cd $HOME/code/tenxrep && claude\"
    end tell
    delay 1
    tell webPane
      set name to \"tenxrep - dev\"
    end tell
    tell apiPane
      set name to \"tenxrep - api\"
    end tell
    tell trClaudeSession
      set name to \"tenxrep - claude\"
    end tell
"
      ;;
    school-comms)
      applescript+="
    -- school-comms: claude tab
    set scSession to current session of $tab_ref
    tell scSession
      write text \"cd $HOME/code/school-comms && source venv/bin/activate && claude\"
    end tell
    delay 1
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
      write text \"cd $HOME/code/main-site && yarn install && yarn start\"
    end tell
    -- main-site: claude tab
    set msClaudeTab to (create tab with default profile)
    set msClaudeSession to current session of msClaudeTab
    tell msClaudeSession
      write text \"cd $HOME/code/main-site && claude\"
    end tell
    delay 1
    tell msDevSession
      set name to \"main-site - dev\"
    end tell
    tell msClaudeSession
      set name to \"main-site - claude\"
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
osascript -e "$applescript" 2>/dev/null

if [[ $? -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}Launched ${#selected_projects[@]} project(s) in iTerm2.${RESET}"
else
  echo -e "${RED}Failed to launch iTerm2. Make sure iTerm2 is running or can be started.${RESET}"
  exit 1
fi
