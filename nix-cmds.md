# Debugging
## Standalone expression evaluator to test scripts 
nix eval -f ./filename.nix

## Check syntax
nix-instantiate --parse << file.nix

## Instantiate without building
nix-instantiate file.nix
nix-instantiate '<nixpkgs/nixos>' -A system --arg configuration ./configuration.nix

## Evaluate specific attributes
nix eval -f ./file.nix variableName

# Building/rebuilding
## Rebuild offline (force build even with derivation failure)
nixos-rebuild switch --option substitute false --keep-going

## Build home-manager config offline
home-manager switch --option fallback true
home-manager switch --option substitute false

## Rebuild and switch to specialisation
nixos-rebuild switch -c XPS-9510_dgpu

## Show current build generations
nix-env --list-generations

# Cleanup

## Show Home Manager generations
home-manager generations

## Remove all old home-manager generations
home-manager expire-generations

## Show Nix system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

## Delete all but the current system generation
sudo nix-env --delete-generations old

## Garbage collect old store data
sudo nix-collect-garbage -d

## Delete specific store files
sudo nix-collect-garbage  --delete-generations 1 2 3

## Clean boot options
sudo /run/current-system/bin/switch-to-configuration boot

# Manage user profiles
nix profile
