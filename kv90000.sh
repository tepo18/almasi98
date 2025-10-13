#!/bin/bash
# ------------------- COLORS & STYLE -------------------
CYAN="\e[96m"
BOLD="\e[1m"
RESET="\e[0m"

# ------------------- PATHS -------------------
BASE_PATH="$HOME"
DOWNLOAD_DIR="/sdcard/Download/Akbar98"

# ------------------- GLOBAL VARIABLES -------------------
CURRENT_REPO=""
REPO_PATH=""
GIT_USER=""

# ------------------- FUNCTIONS -------------------
choose_account() {
    echo -e "${BOLD}${CYAN}Select GitHub account:${RESET}"
    echo "1) tepo18"
    echo "2) almasi98"
    echo "3) tepo98"
    read -rp "Enter number: " ACC_CHOICE
    case $ACC_CHOICE in
        1) GIT_USER="tepo18" ;;
        2) GIT_USER="almasi98" ;;
        3) GIT_USER="tepo98" ;;
        *) echo -e "${CYAN}Invalid choice, defaulting to tepo18${RESET}"; GIT_USER="tepo18" ;;
    esac
    echo -e "${CYAN}GitHub account set to: $GIT_USER${RESET}"
}

switch_repo() {
    echo -ne "${BOLD}${CYAN}Enter repo name to switch/use: ${RESET}"
    read -r REPO_NAME
    CURRENT_REPO="$REPO_NAME"
    REPO_PATH="$BASE_PATH/$CURRENT_REPO"
    if [ ! -d "$REPO_PATH" ]; then
        echo -e "${CYAN}Cloning repo...${RESET}"
        git clone "https://github.com/$GIT_USER/$CURRENT_REPO.git" "$REPO_PATH" || { echo "Clone failed!"; return; }
    else
        echo -e "${CYAN}Using existing repo.${RESET}"
    fi
    cd "$REPO_PATH" || { echo "Cannot enter repo folder."; return; }
    echo -e "${CYAN}Repo switched to: $CURRENT_REPO${RESET}"
}

reset_update_local_repo() {
    if [ -z "$REPO_PATH" ]; then
        echo -e "${CYAN}No repo selected. Please switch repo first.${RESET}"
        return
    fi

    read -rp "Are you sure you want to reset the local repo? This will discard all local changes! (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo -e "${CYAN}Reset cancelled.${RESET}"
        return
    fi

    echo -e "${CYAN}Resetting and updating local repo...${RESET}"
    git reset --hard
    git pull origin main
    echo -e "${CYAN}Local repo reset and updated successfully!${RESET}"
}

main_menu() {
    while true; do
        echo -e "\n${BOLD}${CYAN}========== LOCAL / DEVICE ==========${RESET}"
        echo "1) Select GitHub account"
        echo "2) Switch repo / select repo"
        echo "3) Reset & update local repo"

        echo -e "\n${BOLD}${CYAN}========== MAIN MENU ==========${RESET}"
        echo "4) Create new file"
        echo "5) Edit existing file"
        echo "6) Delete files from repo"
        echo "7) Clear file contents in repo"
        echo "8) Commit changes"
        echo "9) Push to GitHub"
        echo "10) Copy content from download folder to repo file"
        echo "11) Run checker scripts"
        echo "12) Help"
        echo "13) Auto-push all repos"
        echo "14) Exit"

        echo -ne "${BOLD}${CYAN}Choice: ${RESET}"
        read -r CHOICE

        case $CHOICE in
            1) choose_account ;;
            2) switch_repo ;;
            3) reset_update_local_repo ;;
            4)
                read -rp "Enter new filename to create: " NEWFILE
                [ -e "$NEWFILE" ] && echo -e "${CYAN}File exists${RESET}" || (touch "$NEWFILE" && echo -e "${CYAN}File created${RESET}")
                ;;
            5)
                read -rp "Enter filename to edit: " EDITFILE
                [ ! -e "$EDITFILE" ] && echo -e "${CYAN}File not found${RESET}" || nano "$EDITFILE"
                ;;
            6)
                read -rp "Enter filenames to delete (space-separated): " DELFILES
                for f in $DELFILES; do
                    [ -e "$f" ] && rm -i "$f" && echo -e "${CYAN}$f deleted${RESET}" || echo -e "${CYAN}$f not found${RESET}"
                done
                ;;
            7)
                read -rp "Enter filenames to clear contents (space-separated): " CLEARFILES
                for f in $CLEARFILES; do
                    [ -e "$f" ] && >"$f" && echo -e "${CYAN}$f cleared${RESET}" || echo -e "${CYAN}$f not found${RESET}"
                done
                ;;
            8)
                git status
                read -rp "Enter commit message (default: auto update): " MSG
                [ -z "$MSG" ] && MSG="auto update from script"
                git add .
                git commit -m "$MSG" 2>/dev/null || echo -e "${CYAN}Nothing to commit${RESET}"
                ;;
            9)
                read -rp "Push changes to GitHub? (yes/no): " PUSH_ANSWER
                if [ "$PUSH_ANSWER" == "yes" ]; then
                    git add .
                    read -rp "Enter commit message (default: auto update): " MSG
                    [ -z "$MSG" ] && MSG="auto update from script"
                    git commit -m "$MSG" --allow-empty
                    git push "https://github.com/$GIT_USER/$CURRENT_REPO.git" && echo -e "${CYAN}Pushed successfully${RESET}" || echo -e "${CYAN}Push failed${RESET}"
                fi
                ;;
            10)
                read -rp "Enter source filename in download folder: " SRC
                read -rp "Enter target filename in repo: " TARGET
                if [ -f "$DOWNLOAD_DIR/$SRC" ]; then
                    cat "$DOWNLOAD_DIR/$SRC" > "$TARGET" && echo -e "${CYAN}Copied content${RESET}"
                else
                    echo -e "${CYAN}Source file not found${RESET}"
                fi
                ;;
            11)
                echo -e "${CYAN}Checker scripts menu (add as needed)${RESET}"
                ;;
            12) echo "Help: Use numbers to select actions in menu." ;;
            13)
                echo -e "${CYAN}Starting auto push (commit/push/update)...${RESET}"
                git pull origin main --rebase || echo -e "${CYAN}Pull failed${RESET}"
                git add .
                git commit -m "auto update from script" --allow-empty
                git push "https://github.com/$GIT_USER/$CURRENT_REPO.git" && echo -e "${CYAN}Auto-push completed${RESET}" || echo -e "${CYAN}Auto-push failed${RESET}"
                ;;
            14) echo "Exiting."; exit 0 ;;
            *) echo -e "${CYAN}Invalid choice${RESET}" ;;
        esac
    done
}

# ------------------- SCRIPT START -------------------
main_menu



