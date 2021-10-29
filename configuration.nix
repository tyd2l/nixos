{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./cli.nix
      ./machines/current.nix
    ];

#### System

  system.stateVersion = "unstable";
  services.fwupd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  nixpkgs.config.allowUnfree = true;
  
#### Remove old generations

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  
#### Autoupgrade

  system.autoUpgrade.enable = true; 

#### Timezone and locale

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.glibcLocales = pkgs.glibcLocales;
  i18n.supportedLocales = 
  [  "ru_RU.UTF-8/UTF-8"
     "en_US.UTF-8/UTF-8"
  ];
  
#### User account

  users.users.tyd2l = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "lp" ]; 
  };
 
#### Bluetooth

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

#### SSH
  
  services.sshd.enable = true;
  programs.ssh.startAgent = true;
  
#### Sound

  sound.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  pulse.enable = true;
  };
 
#### Printing

  services.printing = {
    enable = true;
    drivers = with pkgs; [ samsungUnifiedLinuxDriver hplip gutenprint canon-cups-ufr2 ];
  };

#### TRIM

  services.fstrim.enable = true;
  
#### ZRAM
  
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
