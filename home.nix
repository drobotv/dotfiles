{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    # rofi = "rofi";
  };
in

{
  home.username = "el";
  home.homeDirectory = "/home/el";
  home.stateVersion = "25.05";

  services.ssh-agent.enable = true;

  programs.git = {
    enable = true;
    userName = "drobotv";
    userEmail = "109414395+drobotv@users.noreply.github.com";
    extraConfig = {
      user.useConfigOnly = true;
      init.defaultBranch = "main";
      credential.helper = "libsecret";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
    };
    initExtra = ''
      	  export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
      	'';
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.packages = with pkgs; [
    bun
    nodejs
    gcc
    opencode
    zed-editor-fhs
    nixfmt
    # rofi
  ];
}
