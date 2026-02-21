#!/bin/bash

# Dev Launcher (Linux/WSL) - start dev environments using tmux sessions
# Usage: ./dev-launcher-linux.sh

# Check for tmux
if ! command -v tmux &>/dev/null; then
  echo "Error: tmux is not installed. Install it with: sudo apt install tmux"
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

echo -e "${BOLD}${CYAN}=== Dev Launcher (Linux) ===${RESET}\n"
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

# Launch tmux sessions for each selected project
setup_keybindings() {
  local session="$1"
  tmux bind-key -n M-Right next-window
  tmux bind-key -n M-Left previous-window
  tmux bind-key -n M-Up select-pane -t :.-
  tmux bind-key -n M-Down select-pane -t :.+
}

launched=0

for project in "${selected_projects[@]}"; do
  case "$project" in
    tenxrep)
      SESSION="tenxrep"
      ROOT_DIR="$HOME/code/tenxrep"

      tmux kill-session -t "$SESSION" 2>/dev/null

      # Dev window: web (left) | api (right)
      tmux new-session -d -s "$SESSION" -n "dev" -c "$ROOT_DIR/tenxrep-web"
      tmux send-keys -t "$SESSION:dev" 'nvm use && npm run dev' C-m
      tmux split-window -h -t "$SESSION:dev" -c "$ROOT_DIR/tenxrep-api"
      tmux send-keys -t "$SESSION:dev.1" 'source venv/bin/activate && python --version && python run.py' C-m

      # Claude window
      tmux new-window -t "$SESSION" -n "claude" -c "$ROOT_DIR"
      tmux send-keys -t "$SESSION:claude" 'claude' C-m

      # Tab title
      tmux set-option -t "$SESSION" set-titles on
      tmux set-option -t "$SESSION" set-titles-string "TenXRep Dev"

      setup_keybindings "$SESSION"
      tmux select-window -t "$SESSION:dev"

      echo -e "${GREEN}[+] Started ${BOLD}tenxrep${RESET}${GREEN} tmux session${RESET}"
      launched=$((launched + 1))
      ;;

    school-comms)
      SESSION="school-comms"
      ROOT_DIR="$HOME/code/school-comms"

      tmux kill-session -t "$SESSION" 2>/dev/null

      # Claude window: venv + claude
      tmux new-session -d -s "$SESSION" -n "claude" -c "$ROOT_DIR"
      tmux send-keys -t "$SESSION:claude" 'source venv/bin/activate && claude' C-m

      # Tab title
      tmux set-option -t "$SESSION" set-titles on
      tmux set-option -t "$SESSION" set-titles-string "School Comms Dev"

      setup_keybindings "$SESSION"
      tmux select-window -t "$SESSION:claude"

      echo -e "${GREEN}[+] Started ${BOLD}school-comms${RESET}${GREEN} tmux session${RESET}"
      launched=$((launched + 1))
      ;;

    main-site)
      SESSION="main-site"
      ROOT_DIR="$HOME/code/main-site"

      tmux kill-session -t "$SESSION" 2>/dev/null

      # Dev window: yarn start
      tmux new-session -d -s "$SESSION" -n "dev" -c "$ROOT_DIR"
      tmux send-keys -t "$SESSION:dev" 'yarn start' C-m

      # Claude window
      tmux new-window -t "$SESSION" -n "claude" -c "$ROOT_DIR"
      tmux send-keys -t "$SESSION:claude" 'claude' C-m

      # Tab title
      tmux set-option -t "$SESSION" set-titles on
      tmux set-option -t "$SESSION" set-titles-string "Main Site Dev"

      setup_keybindings "$SESSION"
      tmux select-window -t "$SESSION:dev"

      echo -e "${GREEN}[+] Started ${BOLD}main-site${RESET}${GREEN} tmux session${RESET}"
      launched=$((launched + 1))
      ;;
  esac
done

if [[ $launched -gt 0 ]]; then
  echo -e "\n${GREEN}${BOLD}Launched ${launched} project(s).${RESET}"
  echo -e "Use ${CYAN}tmux ls${RESET} to see sessions, ${CYAN}tmux attach -t <name>${RESET} to connect."
fi
