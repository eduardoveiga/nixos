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

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.pathsToLink = [ "/libexec" ];
   #nixpkgs.config.allowUnfree = true;
   environment.systemPackages = with pkgs; [
     wget
     vim
     emacs 
     magic-wormhole
     networkmanagerapplet
     gitFull
     rofi
     sakura
     glibcLocales
     tmux
     spotify
   #  discord
     tdlib
     imagemagick
     killall
   #  gocryptfs
     signal-desktop
     youtube-dl
     bc
     tdesktop
     qbittorrent
     mplayer
     docker-compose
     openssl
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
     meld
     httpie
     xclip
     dunst
     qbittorrent
     libnotify
     speedtest-cli
     p7zip
     trash-cli
     lxrandr
     pavucontrol
     fim
     viu
     zsh
     python3
     file
     bash
     bleachbit
     wildmidi
     denemo
     musescore
     ipfs
     zeronet
     utox
     ricochet
     tor
     fractal
     mumble
     syncthing
     alacritty
     ssb-patchwork
     keybase
     keybase-gui
     standardnotes
     lf
     quiterss
     giara
     certbot
     dino
     firefox
     pidgin-with-plugins
     sshpass
     xdotool
     #exodus
     #nano-wallet
     gnupg
     gnome.seahorse
     electron-cash
     electrum
     electrum-ltc
    gparted
     gnome.gnome-disk-utility

];
services.emacs.enable = true;
#services.emacs.package = import /home/edu/.emacs.d { pkgs = pkgs;
#vitualisation.docker.enable = true;
#environment.variables = { GOROOT = [ "${pkgs.go.out}/share/go" ]; };

programs.gnupg.agent.enable = true;
nixpkgs = {
  config = {
    packageOverrides = pkgs: {
      pidgin-with-plugins  = pkgs.pidgin-with-plugins.override {
	plugins = [ pkgs.pidginotr  pkgs.pidgin-xmpp-receipts pkgs.purple-plugin-pack pkgs.pidgin-carbons pkgs.purple-lurch ];
    };
      emacs = pkgs.emacs.override {
        imagemagick = pkgs.imagemagickBig;
      #  tdlib = pkgs.tdlib;
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
   services.openssh.enable = true;
   services.openssh.ports = [ 23 ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   sound.enable = true;
   
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
    };
  

hardware.bluetooth.settings = {
  General = {
    Enable = "Source,Sink,Media,Socket";
  };
};


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

services.logind.lidSwitch = "ignore";

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.edu = {
     isNormalUser = true;
     extraGroups= [ "wheel"  "networkmanager" "docker" ];
     packages = with pkgs; [  dunst deltachat-electron element-desktop ]; # Enable ‘sudo’ for the user.
   };

   users.users.ossystems = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" ];
     packages = with pkgs; [  dunst deltachat-electron element-desktop ];
};
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.dates = "12:00";
  #system.autoUpgrade.persistent = true;
  services.flatpak.enable = true;
  xdg.portal.enable = true;

services = {
    syncthing = {
        enable = true;
        user = "edu";
        dataDir = "/home/edu/sync";
        configDir = "/home/edu/.syncthing";
    };
};



}
