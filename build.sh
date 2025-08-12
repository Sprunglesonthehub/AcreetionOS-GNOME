#!/usr/bin/env bash
# Lead Maintainer: Natalie Spiva <sprungles.me@proton.me>
# Secondary Maintainer: Darren Clift <cobra3282000@live.com>

# ===================== USER CONFIGURATION =====================
GITLAB_REMOTE="ssh://git@darrengames.ddns.net:2402/sprungles/acreetonos-gnome.git"
GITHUB_REMOTE="git@github.com:Sprunglesonthehub/AcreetionOS-GNOME.git"
BRANCH="main"
# ==============================================================

# ========== COLOR CODES ==========
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color
# =================================

function print_header() {
    echo -e "${BLUE}================== AcreetionOS Build Script ==================${NC}"
    echo -e "${YELLOW}Lead Maintainer:${NC} Natalie Spiva <sprungles.me@proton.me>"
    echo -e "${YELLOW}Secondary Maintainer:${NC} Darren Clift <cobra3282000@live.com>"
    echo -e "${BLUE}=============================================================${NC}\n"
}

function require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Error: This script must be run as root!${NC}"
        exit 1
    fi
}

function check_git_config() {
    if ! git config --global user.email >/dev/null; then
        echo -e "${YELLOW}Git user.email is not set.${NC}"
        read -p "Would you like to set up git now? (Y/N): " yn
        if [[ "$yn" =~ ^[Yy] ]]; then
            read -p "Enter your git user.email: " email
            git config --global user.email "$email"
            read -p "Enter your git user.name: " name
            git config --global user.name "$name"
        else
            echo -e "${RED}Cannot continue without git configuration.${NC}"
            exit 1
        fi
    fi
}

function check_archiso() {
    if ! command -v mkarchiso >/dev/null; then
        echo -e "${YELLOW}archiso is not installed. Installing...${NC}"
        pacman -Syy archiso --noconfirm || { echo -e "${RED}Failed to install archiso!${NC}"; exit 1; }
    fi
}

function clean_build() {
    echo -e "${YELLOW}Cleaning previous build artifacts...${NC}"
    rm -rf /var/cache/pacman/* work/ out/
}

function build_iso() {
    echo -e "${GREEN}Building AcreetionOS ISO...${NC}"
    mkarchiso -v -w work -o out/ . || { echo -e "${RED}Build failed!${NC}"; exit 1; }
    echo -e "${GREEN}Build complete! ISO is in the out/ directory.${NC}"
}

function push_to_remote() {
    local remote_name=$1
    local remote_url=$2
    echo -e "${BLUE}Preparing to push to $remote_name...${NC}"
    echo -e "${YELLOW}Cleaning up large build artifacts before push...${NC}"
    rm -rf out/* work/
    git add .
    if ! git remote | grep -q "$remote_name"; then
        git remote add "$remote_name" "$remote_url"
    fi
    git pull "$remote_name" "$BRANCH"
    git commit -m "Automated build push"
    git push "$remote_name" "$BRANCH"
    echo -e "${GREEN}Push to $remote_name complete!${NC}"
}

function main_menu() {
    print_header
    require_root
    check_git_config
    check_archiso

    echo -e "${BLUE}What would you like to do?${NC}"
    echo "1) Build ISO"
    echo "2) Build ISO and push to GitLab"
    echo "3) Build ISO and push to GitHub"
    echo "4) Clean build artifacts only"
    echo "5) Exit"
    read -p "Enter your choice [1-5]: " choice

    case $choice in
        1)
            clean_build
            build_iso
            ;;
        2)
            clean_build
            build_iso
            push_to_remote "gitlab" "$GITLAB_REMOTE"
            ;;
        3)
            clean_build
            build_iso
            push_to_remote "github" "$GITHUB_REMOTE"
            ;;
        4)
            clean_build
            echo -e "${GREEN}Artifacts cleaned.${NC}"
            ;;
        5)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            exit 1
            ;;
    esac
}

main_menu
