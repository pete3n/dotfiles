setupEGPUVars = pkgs.writeShellScriptBin "setupEGPUVars" ''
  #!/bin/sh

  # Set EGPU_ID
  EGPU_ID="10de:2216"
  
  # Extract EGPU_BUS from lspci output
  LSPCI_OUTPUT=$(${pkgs.pciutils}/bin/lspci -nn)
  MATCHED_LINE=$(echo "$LSPCI_OUTPUT" | grep "$EGPU_ID")
  EGPU_BUS=$(echo "$MATCHED_LINE" | cut -d' ' -f1)

  hex_to_dec() {
      printf "%d" "0x$1"
  }
  
  # Convert EGPU_BUS to EGPU_XBUS format
  convertBusToXFormat() {
    local bus="$1"
    local bus1=$(echo $bus | cut -d: -f1)
    local bus2=$(echo $bus | cut -d: -f2 | cut -d. -f1)
    local bus3=$(echo $bus | cut -d. -f2)

    local bus1_dec=$(hex_to_dec $bus1)
    local bus2_dec=$(hex_to_dec $bus2)
    local bus3_dec=$(hex_to_dec $bus3)

    echo "PCI:$bus1_dec:$bus2_dec:$bus3_dec"
  }

  EGPU_XBUS=$(convertBusToXFormat $EGPU_BUS)

  # Conditionally create or remove /etc/egpu.env based on EGPU_BUS
  if [ -z "$EGPU_BUS" ]; then
    # If EGPU_BUS is blank
    if [ -f /etc/egpu.env ]; then
      rm /etc/egpu.env
    fi
  else
    # If EGPU_BUS is not blank
    echo "export EGPU_ID=$EGPU_ID" > /etc/egpu.env
    echo "export EGPU_BUS=$EGPU_BUS" >> /etc/egpu.env
    echo "export EGPU_XBUS=$EGPU_XBUS" >> /etc/egpu.env
  fi
'';
