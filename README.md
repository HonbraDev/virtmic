# virtmic
A simple virtual microphone/speaker sink manager for PulseAudio

## Installation

Copy the executable into `/usr/bin` and give it the correct permissions to execute

    curl -s https://raw.githubusercontent.com/HonbraDev/virtmic/main/virtmic.sh?$(date +%s) | sudo tee /usr/bin/virtmic > /dev/null; sudo chmod +x /usr/bin/virtmic

Inspect the executable

    sudoedit /usr/bin/virtmic

## Usage

Create a device pair

    virtmic create <id>

Delete a device pair

    virtmic delete <id>

List all devices

    virtmic list

Delete all devices

    virtmic deleteall
