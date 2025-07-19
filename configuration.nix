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
  
  networking.hostName = "gentoo";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
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
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = false;
  services.desktopManager.gnome.enable = true;
  #services.xserver.windowManager.qtile.enable = true;
  #services.xserver.windowManager.qtile.extraPackages = p: with p; [ qtile-extras ];
  #services.picom.enable = true;

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


  #services.udev.extraRules = builtins.readFile ./udev-rules/70-#madlions.rules;



  environment.etc."os-release".text = ''
    NAME="Gentoo Linux"
    ID=gentoo
    PRETTY_NAME="Gentoo Linux"
    ANSI_COLOR="0;38;2;0;112;192"
    HOME_URL="https://www.freebsd.org/"
    SUPPORT_URL="https://www.freebsd.org/support.html"
    BUG_REPORT_URL="https://bugs.freebsd.org/"
    LOGO="gentoo"
    DEFAULT_HOSTNAME=gentoo
  '';

  services.printing.enable = true;

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.flatpak.enable = true;

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    users = ["valutta"];
    keepEnv = true;
    persist = true;
  }];
  users.users.valutta = { 
    isNormalUser = true;
    shell = pkgs.fish;
    description = "valutta";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      nano
      vim
      zed-editor
      fish
      starship
      kitty
      btop
      fastfetch
      neofetch
      inxi
      pfetch
      blender
      emacs
      spicetify-cli
      lunar-client
      hiddify-app
      vlc
      librewolf
      rustup
      rustc
      steam
      protonplus
      steam-unwrapped
      steam-run
      cargo
      hyprland
      hypridle
      searxng
      hyprcursor
      hyprpanel
      astal.io
      astal.gjs
      astal.tray
      astal.cava
      astal.astal3
      astal.astal4
      astal.notifd
      astal.source
      swww
      waypaper
      rofi
      tmux
      waybar
      slurp
      grim
      mpvpaper
      hyprshot
      wl-clipboard
      nodejs
      mullvad-vpn
      iwd
      gcc
      xorg.libX11
      xorg.libXinerama
      xorg.libXrandr
      xorg.xorgproto
      xorg.libXcursor
      xorg.libXfixes
      xorg.libXinerama
      xorg.libXext
      swaynotificationcenter
      libsForQt5.xwaylandvideobridge
      neovim
      xfce.thunar
      yazi
      astal.gjs
      gjs
      gtk3
      alacritty
      firefox
      brave
      vesktop
      oh-my-fish
      telegram-desktop
      spotify
      obs-studio
      wine
      winetricks
      ntfs3g
      prismlauncher
      easyeffects
      pulseaudio
      cava
      dunst
      lxappearance
      libsForQt5.qt5ct
      kdePackages.qt6ct
      pkgs.gnome-themes-extra
      papirus-icon-theme
      kitty
      neofetch
      picom
      python313Packages.qtile-extras
      python313Packages.dbus-next
      playerctl
      rofi
      dunst
      stow
      nwg-look
      alsa-utils
      nitrogen
      xclip
      scrot
      chromium
      #lsusb
      usbutils
    ];
  };


  fonts = {
    packages = with pkgs; [
     nerd-fonts.iosevka
     nerd-fonts.symbols-only
    ];
    fontconfig.enable = true;
  };

  environment.systemPackages = with pkgs; [
    linuxHeaders
    ags
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}

