#!/bin/bash

# Ensure rbenv is loaded
export HOME="/home/ubuntu"
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$($RBENV_ROOT/bin/rbenv init -)"

# Set the correct Ruby version
rbenv shell 3.2.2

# Navigate to your app
cd "$HOME/gameday"

# Start Puma
exec bundle exec puma -C config/puma.rb
