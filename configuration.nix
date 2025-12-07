{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  #networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  networking.wireless.iwd.enable = true;
  programs.steam.enable = true;

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; 
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.dconf.enable = true;
  qt.enable = true; 

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true; 
    audio.enable = true;
  }; 
  security.rtkit.enable = true;
  programs.fish.enable = true;
  programs.amnezia-vpn.enable = true;
  
services.flatpak.enable = true;

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    users = ["v3g7"];
    keepEnv = true;
    persist = true;
  }];
  users.users.v3g7 = { 
    isNormalUser = true;
    shell = pkgs.fish;
    description = "v3g7";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      nano
      vim
      fish
      starship
      btop
      fastfetch
      pfetch
      vlc
      figma-linux
      figma-agent
      tor-browser
      pavucontrol   
      git
      amnezia-vpn
      rustup
      rustc
      steam
      protonplus
      steam-unwrapped
      steam-run
      cargo
      hyprland
      hypridle
      hyprcursor
      hyprpanel
      swww
      waypaper
      rofi
      waybar
      cava
      slurp
      grim
      mpvpaper
      wl-clipboard
      nodejs
      iwd
      gcc
      xwayland
      neovim
      vicinae
      alacritty
      firefox
      vesktop
      telegram-desktop
      spotify
      easyeffects
      papirus-icon-theme
      neofetch
      rofi
      dunst
      nwg-look
      alsa-utils
      usbutils
    ];
  };

  fonts = {
    packages = with pkgs; [
     nerd-fonts.iosevka
     nerd-fonts.symbols-only
     maple-mono.NF
    ];
    fontconfig.enable = true;
  };

  environment.systemPackages = with pkgs; [
    linuxHeaders
    ags
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
