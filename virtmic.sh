# Add device
if [ "$1" == "add" ] || [ "$1" == "create" ] || [ "$1" == "a" ] || [ "$1" == "c" ]; then

  # Check if there's no ID provided
  if [ "$2" == "" ]; then
    echo "Please enter the device ID."
    exit
  fi

  # Check if ID already exists
  LISTDEVICES=$(pactl list short modules | grep "sink_name=virtmic$2")
  if [[ -n $LISTDEVICES ]]; then
    echo "A device with that ID already exists (virtmic$2)."
    exit
  fi

  # Create device
  echo "Creating virtual device with ID $2 (virtmic$2)."
  pactl load-module module-null-sink sink_name=virtmic$2 \
    sink_properties=device.description=Virtual_speaker_$2 >/dev/null
  pactl load-module module-remap-source \
    master=virtmic$2.monitor source_name=virtmic$2 \
    source_properties=device.description=Virtual_microphone_$2 >/dev/null
  exit

fi

# Remove device
if [ "$1" == "remove" ] || [ "$1" == "delete" ] || [ "$1" == "r" ] || [ "$1" == "d" ]; then

  # Check if there's no ID provided
  if [ "$2" == "" ]; then
    echo "Please enter the device ID (without virtmic)."
    exit
  fi

  # Check if ID doesn't exist
  LISTDEVICES=$(pactl list short modules | grep "sink_name=virtmic$2")
  if [[ ! -n $LISTDEVICES ]]; then
    echo "A device with that ID doesn't exist."
    exit
  fi

  # Remove device
  echo "Removing virtual device with ID $2 (virtmic$2)."
  pactl list short modules | grep "sink_name=virtmic$2" | cut -f1 | xargs -L1 pactl unload-module
  exit

fi

# Remove all devices
if [ "$1" == "removeall" ] || [ "$1" == "deleteall" ] || [ "$1" == "rall" ] || [ "$1" == "dall" ]; then

  # Check if there are any devices with the prefix virtmic
  LISTDEVICES=$(pactl list short modules | grep "sink_name=virtmic" | cut -f3 | cut -d ' ' -f1 | cut -c 18-)
  if [[ -n $LISTDEVICES ]]; then
    echo "Removing all virtual devices."
    for DEVICE in $LISTDEVICES; do
      pactl list short modules | grep "sink_name=virtmic$DEVICE" | cut -f1 | xargs -L1 pactl unload-module
    done
    exit
  fi

  echo "No active virtual devices found."
  exit

fi

# List devices
if [ "$1" == "list" ] || [ "$1" == "l" ]; then

  # Check if there are any devices with the prefix virtmic
  LISTDEVICES=$(pactl list short modules | grep "sink_name=virtmic" | cut -f3 | cut -d ' ' -f1 | cut -c 18-)
  if [[ -n $LISTDEVICES ]]; then
    echo Active virtual devices:
    for DEVICE in $LISTDEVICES; do
      echo " $DEVICE (virtmic$DEVICE)"
    done
    exit
  fi

  echo "No active virtual devices found."
  exit

fi

# Print the help menu
echo "Available arguments:
  a[dd]    | c[reate] <device ID>
  r[emove] | d[elete] <device ID>
  r[emove]all | d[elete]all
  l[ist]"
