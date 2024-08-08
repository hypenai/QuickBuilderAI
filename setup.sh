#!/bin/bash

# Script to set up a free open-source AI chatbot environment using Ollama

# Define bot name
BOT_NAME="QuickBuilderOllama"

# Define installation directories
INSTALL_DIR="$HOME/$BOT_NAME"
VENV_DIR="$INSTALL_DIR/venv"

# Function to print messages
print_message() {
    echo "==> $1"
}

print_message "Starting setup for $BOT_NAME..."

# Create installation directory
print_message "Creating installation directory at $INSTALL_DIR..."
mkdir -p $INSTALL_DIR

# Navigate to installation directory
cd $INSTALL_DIR

# Update package list and install Python
print_message "Updating package list and installing Python..."
sudo apt-get update -y
sudo apt-get install -y python3 python3-venv python3-pip

# Set up virtual environment
print_message "Setting up virtual environment..."
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate

# Install necessary Python packages
print_message "Installing necessary Python packages..."
pip install --upgrade pip
pip install requests flask

# Create a basic Flask app for the chatbot using Ollama's API
print_message "Creating basic Flask app..."
cat <<EOL > app.py
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Replace with your Ollama API key or set it as an environment variable
OLLAMA_API_KEY = "YOUR_OLLAMA_API_KEY"

@app.route('/chat', methods=['POST'])
def chat():
    user_input = request.json.get('input')
    headers = {
        'Authorization': f'Bearer {OLLAMA_API_KEY}',
        'Content-Type': 'application/json'
    }
    data = {
        'prompt': user_input
    }
    response = requests.post('https://api.ollama.com/v1/complete', headers=headers, json=data)
    response_data = response.json()
    return jsonify(response_data['choices'][0]['text'].strip())

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOL

# Create a .gitignore file
print_message "Creating .gitignore file..."
cat <<EOL > .gitignore
venv/
__pycache__/
*.pyc
instance/
.webassets-cache
.DS_Store
EOL

# Create a LICENSE file
print_message "Creating LICENSE file..."
cat <<EOL > LICENSE
MIT License

Copyright (c) $(date +%Y) YourName

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL

# Create a README file
print_message "Creating README file..."
cat <<EOL > README.md
# $BOT_NAME

## Description

$BOT_NAME is an open-source AI chatbot built using Ollama's model and Flask. This project is designed to be easy to set up and customize for your own use.

## Setup Instructions

### Prerequisites

- Python 3.x
- pip
- Ollama API key

### Installation

1. Clone the repository:
    \`\`\`
    git clone https://github.com/yourusername/$BOT_NAME.git
    cd $BOT_NAME
    \`\`\`

2. Set up the virtual environment and install dependencies:
    \`\`\`
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    \`\`\`

3. Add your Ollama API key in \`app.py\`:
    \`\`\`
    OLLAMA_API_KEY = "YOUR_OLLAMA_API_KEY"
    \`\`\`

4. Run the Flask app:
    \`\`\`
    python app.py
    \`\`\`

### Usage

Send a POST request to \`/chat\` with JSON payload:
\`\`\`
{
    "input": "Hello, how are you?"
}
\`\`\`

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
EOL

# Create requirements file
print_message "Creating requirements file..."
pip freeze > requirements.txt

print_message "Setup complete! To start the chatbot, run:"
print_message "source $VENV_DIR/bin/activate && python app.py"

# Deactivate virtual environment
deactivate
