# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   networking.hostName = "nixos"; # Define your hostname.
   networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "pt_BR.UTF-8";
   i18n.supportedLocales = [ "all" ];
   #console = {
    # font = "Lat2-Terminus16";
    # keyMap = "br-abnt2";
   #};

  # Set your time zone.
   time.timeZone = "America/Sao_Paulo";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.pathsToLink = [ "/libexec" ];
   #nixpkgs.config.allowUnfree = true;
   environment.systemPackages = with pkgs; [
     wget
     vim
     firefox 
     emacs 
     magic-wormhole
     networkmanagerapplet
     git
     rofi
     sakura
     glibcLocales
     tmux
     spotify
     discord
     tdlib
     imagemagick
     killall
     gocryptfs
     signal-desktop
     youtube-dl
     (python3.withPackages(ps: with ps; [ numpy pillow]))
     bc
     tdesktop
     qbittorrent
     mplayer
     docker-compose
     openssl
     dino
     unrar
     anydesk
     octaveFull
     xorg.xbacklight
     gnumake
     gcc
     go
     jq
     curlie
     scrot
   ];

services.emacs.enable = true;
virtualisation.docker.enable = true;
environment.variables = { GOROOT = [ "${pkgs.go.out}/share/go" ]; };

nixpkgs = {
  config = {
    packageOverrides = pkgs: {
      emacs = pkgs.emacs.override {
        imagemagick = pkgs.imagemagickBig;
      };

    };
   allowUnfree = true;
  };
};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
   #services.xserver.enable = true;
   services.xserver.xkbModel = "abnt2";
   services.xserver.layout = "br";
   services.xserver.xkbVariant = "abnt2";
   console.useXkbConfig = true;

   
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
   services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
   #services.xserver.displayManager.sddm.enable = true;
   #services.xserver.desktopManager.plasma5.enable = true;
    services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

   
    displayManager = {
        defaultSession = "none+i3";
   };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.edu = {
     isNormalUser = true;
     extraGroups = [ "wheel"  "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
   };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
