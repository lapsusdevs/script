#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Git is installed
if ! command_exists git; then
  echo 'Git is not installed. Installing Git...'
  # Install Git based on package manager
  if command_exists apt-get; then
    sudo apt-get install -y git
  elif command_exists yum; then
    sudo yum install -y git
  elif command_exists dnf; then
    sudo dnf install -y git
  else
    echo "Unable to install Git. Please install it manually and try again." >&2
    exit 1
  fi
fi

# Check if Curl is installed
if ! command_exists curl; then
  echo 'Curl is not installed. Installing Curl...'
  # Install Curl based on package manager
  if command_exists apt-get; then
    sudo apt-get install -y curl
  elif command_exists yum; then
    sudo yum install -y curl
  elif command_exists dnf; then
    sudo dnf install -y curl
  else
    echo "Unable to install Curl. Please install it manually and try again." >&2
    exit 1
  fi
fi

curl -s https://deb.nodesource.com/setup_18.x | sudo bash

# Check if Node.js is installed
if ! command_exists node; then
  echo 'Node.js is not installed. Installing Node.js...'
  # Install Node.js based on package manager
  if command_exists apt-get; then
    sudo apt-get install -y nodejs
  elif command_exists yum; then
    sudo yum install -y nodejs
  elif command_exists dnf; then
    sudo dnf install -y nodejs
  else
    echo "Unable to install Node.js. Please install it manually and try again." >&2
    exit 1
  fi
fi

# Check if NPM is installed
if ! command_exists npm; then
  echo 'NPM is not installed. Installing NPM...'
  # Install NPM based on package manager
  if command_exists apt-get; then
    sudo apt-get install -y npm
  elif command_exists yum; then
    sudo yum install -y npm
  elif command_exists dnf; then
    sudo dnf install -y npm
  else
    echo "Unable to install NPM. Please install it manually and try again." >&2
    exit 1
  fi
fi

# Clone the GitHub repository
echo "Cloning repository..."
git clone https://github.com/ManucrackYT/LapsusClient.git

# Change directory to the cloned repository
cd LapsusClient

# Install dependencies using npm
echo "Installing dependencies..."
npm install

# Start the application with Node.js
echo "Starting the application..."
node .

# Optional: You can add additional commands or configurations as needed
