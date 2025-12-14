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
  boot.kernelModules = [ "rtw88_8822bu" ];
  hardware.enableRedistributableFirmware = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.networkmanager.wifi.powersave = false;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  #networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  #networking.wireless.enable = true;
  programs.steam.enable = true;
  programs.kdeconnect.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.libinput.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="1054", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="1054", TAG+="uaccess"
  '';


  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    #fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };

    users.users.tpws = {
    isSystemUser = true;
    group = "tpws";
  };
  users.groups.tpws = {};

  systemd.services.zapret = {
    description = "Zapret DPI bypass for Roblox";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ iptables nftables ipset gawk coreutils ];

    serviceConfig = {
      Type = "forking";
      Restart = "always";
      RestartSec = "10sec";
      ExecStart = "${pkgs.zapret}/bin/zapret start";
      ExecStop = "${pkgs.zapret}/bin/zapret stop";
    };

    environment = {
      # Комбинированный режим: nfqws для UDP + tpws для HTTPS/WS
      MODE = "nfqws,tpws";

      # Включаем обработку HTTP и HTTPS
      MODE_HTTP = "1";
      MODE_HTTPS = "1";

      # Параметры для tpws (для сайта и аутентификации)
      TPWS_OPT = "--hostlist=/etc/zapret/hostlist-roblox.txt --port=80,443 --split-pos=3 --oob";

      # Параметры для nfqws (основной обход UDP для игр)
      NFQWS_OPT_DESYNC = "--dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-any-protocol --dpi-desync-cutoff=n2";

      # Фильтр только по нужным UDP-портам Roblox (чтобы не ломать весь трафик)
      NFQWS_PORTS_UDP = "49152-65535";

      # Ограничение по CIDR игровых серверов (чтобы desync применялся только к ним)
      NFQWS_OPT = "--filter-udp=49152-65535 --ipset=/etc/zapret/ipset/roblox-cidr.txt";

      DISABLE_IPV6 = "1";  # Если IPv6 не нужен
    };
  };

  # Расширенный список доменов для tpws (покрывает сайт, студию и API)
  environment.etc."zapret/hostlist-roblox.txt".text = ''
    roblox.com
    www.roblox.com
    auth.roblox.com
    api.roblox.com
    apis.roblox.com
    assetgame.roblox.com
    assetdelivery.roblox.com
    catalog.roblox.com
    avatar.roblox.com
    economy.roblox.com
    games.roblox.com
    friends.roblox.com
    groups.roblox.com
    notifications.roblox.com
    presence.roblox.com
    realtime.roblox.com
    voice.roblox.com
    chat.roblox.com
    titanium.roblox.com
    edge-term4.roblox.com
    rbxcdn.com
    setup.rbxcdn.com
  '';

  # CIDR-блоки игровых серверов Roblox (основные на декабрь 2025)
  environment.etc."zapret/ipset/roblox-cidr.txt".text = ''
    128.116.0.0/17
    # Добавьте сюда другие, если найдёте актуальные (проверьте в обсуждениях bol-van/zapret #1928)
  '';

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
  #services.desktopManager.gnome.enable = false;
  services.desktopManager.plasma6.enable = true;

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

  environment.etc."libinput/local-overrides.quirks".text = ''
  [Glorious Model O PRO Wireless]
  MatchName=Glorious Model O PRO Wireless    
  ModelBouncingKeys=1
  '';

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
      eza
      tree
      btop
      fastfetch
      pfetch
      vlc
      nemo
      figma-linux
      figma-agent
      tor-browser
      pavucontrol
      git
      amnezia-vpn
      rustup
      rustc
      steam
      brave
      libinput
      protonplus
      steam-unwrapped
      #vercel
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
      bibata-cursors
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
      mullvad-browser
      librewolf
      #obs-studio
      libratbag
      lunar-client
      #badlion-client
      zapret
      vesktop
      telegram-desktop
      spotify
      easyeffects
      papirus-icon-theme
      neofetch
      vimPlugins.LazyVim
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
