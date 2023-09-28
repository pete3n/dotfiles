#!/run/current-system/sw/bin/bash

# Directory paths
HARDWARE_DIR="./hardware"
SOFTWARE_DIR="./software"
USER_DIR="./user"
PROFILE_NAME=""
TEST=0

# Help function
show_help() {
    printf "\n\n"
    echo "Usage: $0 -w hardware [-s software1 software2 ...] [-u user1 user2 ...] [-p profile] [-t test]"
    printf "\n"
    echo "Available hardware modules:"
    ls $HARDWARE_DIR | grep ^hw_ | sed -e 's/hw_//' -e 's/.nix//'
    printf "\n"
    echo "Available software modules (default is all software):"
    ls $SOFTWARE_DIR | grep ^sw_ | sed -e 's/sw_//' -e 's/.nix//'
    printf "\n"
    echo "Available user modules (default is all users):"
    ls $USER_DIR | grep ^user- | sed -e 's/user-//' -e 's/.nix//'
    printf "\n"
    echo "(Optional) -p --profile: user defined name for configuration"
    echo "(Optional) -t --test: test configuration"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -w|--hardware)
    HARDWARE="hw_$2.nix"
    shift
    shift
    ;;
    -s|--software)
    shift
    SOFTWARE=()
    while [[ $# -gt 0 && ! $1 =~ $- ]]
    do
        SOFTWARE+=("sw_$1.nix")
	shift
    done
    ;;
    -u|--users)
    shift
    USERS=()
    while [[ $# -gt 0 && ! $1 =~ ^- ]]
    do
        USERS+=("$1")
        shift
    done
    ;;
    -p|--profile)
    PROFILE="$2"
    shift
    shift
    ;;
    -t|--test)
    TEST=1
    shift
    ;;
    *)
    show_help
    ;;
esac
done

# Check if hardware was provided
if [[ -z "$HARDWARE" ]]; then
    echo "Error: Hardware configuration not specified."
    show_help
fi

# CHeck if software was provided, default to all
if [[ ${#SOFTWARE[@]} -eq 0 ]]; then
    echo "Defaulting to all software modules."
    SOFTWARE=( $(ls $SOFTWARE_DIR | grep ^sw_) )
    echo "Using software modules: ${SOFTWARE[@]}"
fi

# Check if users were provided, default to all
if [[ ${#USERS[@]} -eq 0 ]]; then
    echo "Defaulting to all user modules."
    USERS=( $(ls $USER_DIR | grep ^user- | sed -e 's/user-//' -e 's/.nix//') )
    echo "Using user modules: ${USERS[@]}"
fi

# Create the list of user imports
USER_IMPORTS=""
for user in "${USERS[@]}"; do
    USER_IMPORTS+="\n  $USER_DIR/user-$user.nix"
done

# Create the list of system software imports
SOFTWARE_IMPORTS=""
for software in "${SOFTWARE[@]}"; do
    SOFTWARE_IMPORTS+="\n $SOFTWARE_DIR/$software"
done

# Modify the configuration.template
sed -e "s~##HARDWARE_IMPORT##~$HARDWARE_DIR/$HARDWARE~" \
    -e "s~##USER_IMPORTS##~$USER_IMPORTS~" \
    -e "s~##SYSTEM_SOFTWARE_IMPORTS##~$SOFTWARE_IMPORTS~" \
    configuration.template > configuration.nix

# Build the configuration
PROFILE_FLAG=""
if [[ ! -z "$PROFILE" ]]; then
  PROFILE_NAME="${PROFILE}_NixOS-$(nixos-version)_Linux Kernel-$(uname -r)_BUILT ON-$(date '+%Y-%m-%d')_BUILT AT-$(date '+%H-%M-%S')"
  PROFILE_NAME=${PROFILE_NAME// /_}
  PROFILE_NAME=${PROFILE_NAME//\(/_}
  PROFILE_NAME=${PROFILE_NAME//\)/_}
  PROFILE_FLAG="--profile-name ${PROFILE_NAME}"
fi

if [[ $TEST -eq 1 ]]; then
  nix-instantiate '<nixpkgs/nixos>' -A system --arg configuration ./configuration.nix
else
  echo $PROFILE_NAME
  nixos-rebuild switch $PROFILE_FLAG
fi
