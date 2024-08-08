#!/bin/bash

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Check dependencies
check_dependencies() {
    # Check if Node.js > 15 is installed, if not install Node.js 20
    if command_exists node; then
        NODE_VERSION=$(node -v | sed 's/v//')
        if (( $(echo "$NODE_VERSION < 16" | bc -l) )); then
            echo "Node.js version is 15 or lower. Installing Node.js 20..."
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
        fi
    else
        echo "Node.js is not installed. Installing Node.js 20..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi

    # Check if unzip is installed
    if ! command_exists unzip; then
        echo "unzip is not installed. Installing unzip..."
        sudo apt-get update && sudo apt-get install -y unzip
    fi

    # Check if git is installed
    if ! command_exists git; then
        echo "git is not installed. Installing git..."
        sudo apt-get update && sudo apt-get install -y git
    fi

    # Check and install basic components (curl and build-essential)
    if ! command_exists curl; then
        echo "curl is not installed. Installing curl..."
        sudo apt-get update && sudo apt-get install -y curl
    fi

    if ! dpkg -s build-essential &> /dev/null; then
        echo "build-essential is not installed. Installing build-essential..."
        sudo apt-get update && sudo apt-get install -y build-essential
    fi
}

# Install Lapsus Client
install_client() {
    # Clone the repository
    REPO_URL="https://github.com/ManucrackYT/LapsusClient"
    TARGET_DIR="LapsusClient"
    if [ -d "$TARGET_DIR" ]; then
        echo "Directory $TARGET_DIR already exists. Pulling the latest changes..."
        cd $TARGET_DIR
        git pull
    else
        echo "Cloning the repository..."
        git clone $REPO_URL
        cd $TARGET_DIR
    fi

    # Install Yarn
    if ! command_exists yarn; then
        echo "Yarn is not installed. Installing Yarn..."
        npm install -g yarn
    fi

    # Install npm dependencies and run the application
    echo "Installing npm dependencies..."
    npm install

    echo "Running the application..."
    node .
}

# Update Lapsus Client
update_client() {
    TARGET_DIR="LapsusClient"
    if [ ! -d "$TARGET_DIR" ]; then
        echo "LapsusClient is not installed. Please install it first."
        return
    fi

    echo "WARNING: Please backup your config.json and database.sqlite files before proceeding."
    read -p "Press Enter to continue or Ctrl+C to cancel."

    cd $TARGET_DIR
    git fetch --all
    git reset --hard origin/main
    echo "LapsusClient has been updated. Restoring config.json and database.sqlite files."
    # Uncomment the following lines if you want to restore from backups automatically
    # cp config.json.bak config.json
    # cp database.sqlite.bak database.sqlite
}

# Uninstall Lapsus Client
uninstall_client() {
    TARGET_DIR="LapsusClient"
    if [ -d "$TARGET_DIR" ]; then
        echo "Removing LapsusClient directory..."
        rm -rf $TARGET_DIR
        echo "LapsusClient has been uninstalled."
    else
        echo "LapsusClient directory not found."
    fi
}

# Display menu
show_menu() {
    echo "1. Install Lapsus Client"
    echo "2. Update Lapsus Client"
    echo "3. Uninstall Lapsus Client"
    echo "4. Exit"
}

# Main script
main() {
    check_dependencies

    while true; do
        show_menu
        read -p "Choose an option: " choice

        case $choice in
            1)
                install_client
                ;;
            2)
                update_client
                ;;
            3)
                uninstall_client
                ;;
            4)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done
}

main
