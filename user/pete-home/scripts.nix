# Custom user shell scripts
{ config, lib, pkgs, ... }:

let

  # Script to launch Steam Flatpak and pass an environment variable
# # to give access to external libraries
  steamFlatpakScript = pkgs.writeShellScriptBin "steam-flatpak" ''
    echo "STEAM LIBRARY IS: $STEAM_LIBRARY"
    dbus-run-session flatpak --filesystem=$STEAM_LIBRARY run com.valvesoftware.Steam
  '';

  # Script to allow offloading abitrary programs to the GPU
  # Check xrandr --listproviders to find the corret PROVIDER name
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=modesetting
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';

  # Script to copy the tmux buffer to system clipboard
  tmuxCopy = pkgs.writeShellScriptBin "tcopy" ''
    tmux save-buffer - | xclip -i -sel clipboard
  '';

  # Script to paste the system clipboard to the tmux buffer
  tmuxPaste = pkgs.writeShellScriptBin "tpaste" ''
    xclip -o -sel clipboard | tmux load-buffer -
  '';

  # Script to configure touchpad settings
  touchpadSettings = pkgs.writeShellScriptBin "setTouchpad" ''
   # Extract the touchpad device name from the xinput list
    touchpad_device=$(xinput list | grep -i touchpad | sed -n 's/.*id=\([0-9]*\).*pointer.*/\1/p')

    if [ -n "$touchpad_device" ]; then
      # Set Natural Scrolling
      xinput set-prop "$touchpad_device" "libinput Natural Scrolling Enabled" 1

      # Set two-finger right-click 
      xinput set-prop "$touchpad_device" "libinput Click Method Enabled" 0 1

      # Disable touchpad while typing
      xinput set-prop "$touchpad_device" "libinput Disable While Typing Enabled" 1

      echo "Settings applied to device ID = $touchpad_device"
    else
      echo "Touchpad device not found!"
    fi
  '';

in {
  home.packages = with pkgs; [ 
    nvidia-offload
    tmuxCopy
    tmuxPaste
    touchpadSettings
  ] ++ (
    if builtins.pathExists 
    "/var/lib/flatpak/app/com.valvesoftware.Steam" then
      [steamFlatpakScript] else []);
}
