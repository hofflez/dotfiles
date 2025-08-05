# sudo darwin-rebuild switch --flake ~/dotfiles/nix
{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {

      system.primaryUser = "bryan";

      # --- Nix Packages

      environment.systemPackages =
        [ 
	  pkgs.neovim
        ];

      # --- Homebrew

      homebrew = {
        enable = true;
	brews = [
	  "mas" # mas cli to search AppStore app ids "mas search <app-name>"
	  "stow" # dotfiles manager
	];
        casks = [
          "ghostty"
        ];
	masApps = {
	  "Todoist" = 585829637;
	  "Bitwarden" = 1352778147;	
	};
	onActivation.cleanup = "zap";
	# auto update brew apps, whenever we rebuild
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      # --- Fonts
	
      fonts.packages = [
         pkgs.nerd-fonts.fira-code
      ];

      # --- System Settings (mynixos.com go to options/system/defaults)

      system.defaults = {
	# auto hide the dock
        dock.autohide = true;
	# dock apps
	dock.persistent-apps = [
	  "System/Applications/Launchpad.app"
	  "Applications/Ghostty.app"
	  "Applications/Todoist.app"
	];
	# don't show recent apps
	dock.show-recents = false;
      };

      # --- Defaults

      # Allow packages which are marked as broken
      nixpkgs.config.allowBroken = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Bryans-Mac-Studio
    darwinConfigurations."Bryans-Mac-Studio" = nix-darwin.lib.darwinSystem {
      modules = [ 
       configuration 
       nix-homebrew.darwinModules.nix-homebrew
       {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            # enableRosetta = true;

            # User owning the Homebrew prefix
            user = "bryan";
          };
        }
      ];
    };
  };
}
