# Script and services to download DoD certs, smartcard service, and set Firefox policy
{ config, lib, pkgs, ... }:

let
  certsURL = "https://militarycac.com/maccerts/AllCerts.zip"; 
  getDodCerts = pkgs.writeShellScriptBin "getDodCerts" ''
    export PATH=${pkgs.curl}/bin:${pkgs.unzip}/bin:$PATH
    CERT_DIR="/usr/share/dod_certs"
    
    # Check if the directory exists, if not create it
    [ ! -d "$CERT_DIR" ] && mkdir -p "$CERT_DIR"
    
    # Download and extract the zip file
    curl -sL ${certsURL} -o /tmp/DoDCerts.zip
    unzip -o /tmp/DoDCerts.zip -d "$CERT_DIR"
    
    # Clean up the temporary zip file
    rm -f /tmp/DoDCerts.zip

    # Generate policies.json with the list of certificates
    certs_nix="["
    for cert in $CERT_DIR/*.cer; do
      certs_nix="$certs_nix\"$cert\" "
    done
    certs_nix="$certs_nix]"

    echo "$certs_nix" > $CERT_DIR/dod_certs.nix
  '';

  opensc = pkgs.opensc;
  openscLibPath = "${opensc}/lib/opensc-pkcs11.so";

  # Create the list of DoD CA certs to install
  dodCertsPoliciesPath = "/usr/share/dod_certs/dod_certs.nix";
  dodCerts = if builtins.pathExists dodCertsPoliciesPath
             then import dodCertsPoliciesPath
             else [];

in {
  systemd.services.getDodCerts = {
    description = "Download and Extract DoD Certificates";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${getDodCerts}/bin/getDodCerts";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
    unitConfig = {
      ConditionPathExists = "!/var/lib/getDodCerts-done";
    };
    postStart = ''touch /var/lib/getDodCerts-done'';
  };

  # Install opensc
  environment.systemPackages = [ opensc ];

  # Enable smart card daemon
  services.pcscd.enable = true;

  # Configure Firefox to use opensc PKCS11 and DoD CAs
  programs.firefox = {
    enable = true;
    policies = {
      SecurityDevices = {
        Add = {
          OpenSC = openscLibPath;
        };
      };
      Certificates = {
        ImportEnterpriseRoots = true;
        Install = dodCerts;
      };
    };
  };
}
