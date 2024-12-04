# home.nix

{ config, pkgs, ... }:

{
  # this is internal compatibility configuration 
  # for home-manager, don't change this!
  home.stateVersion = "23.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pkgs.azure-cli
    pkgs.colima
    pkgs.coreutils
    pkgs.curl
    pkgs.direnv
    pkgs.docker-client
    pkgs.docker-buildx
    pkgs.eza
    pkgs.git
    pkgs.jetbrains.datagrip
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubelogin
    pkgs.kubernetes-helm
    pkgs.minikube
    pkgs.nix-direnv
    pkgs.nodejs
    pkgs.pyright
    pkgs.python312
    pkgs.ripgrep
    pkgs.signal-desktop
    pkgs.spaceship-prompt
    pkgs.speedtest-cli
    pkgs.spotify
    pkgs.terraform
    pkgs.terraform-ls
    pkgs.tree-sitter
    pkgs.vim
    pkgs.wezterm
    pkgs.wget
  ];

  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.tmux.enable = true;
  programs.jq.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # bit hacky way to source the theme but it works :shrug:
    initExtra = ''
      source ${pkgs.spaceship-prompt}/share/zsh/themes/spaceship.zsh-theme;

      if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else
        eval "$(/usr/local/bin/brew shellenv)"
      fi

      source ~/.functions
      source ~/.extra
    '';

    shellAliases = {
      ll = "eza -l";
      update-nix = "nix run nix-darwin -- switch --flake ~/code/nix-config";
      pythonShell = "nix develop ~/code/nix-config/utils/python-dev#python311 -c $SHELL";
      k = "kubectl -n data";
      h = "helm --namespace data";
    };

    history = {
      size = 1000000;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "terraform" "poetry"];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    MANPAGER = "less -X";
    PYTHONBREAKPOINT = "pudb.set_trace";
    BAT_THEME = "TwoDark";

    # correct grey for zsh autocomplete
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=243";

    # no async fetching of azure sub on every prompt
    SPACESHIP_AZURE_SHOW = "false";
    SPACESHIP_PROMPT_ASYNC = "false"; # irritating af
    SPACESHIP_DOCKER_SHOW = "false"; # what good does the version do

    # Always-true work stuff
    AIRFLOW_UID = 502;
    AIRFLOW_GID = 0;
    AIRFLOW_PLATFORM = "linux/arm64";
  };

  home.file.".vimrc".source = ./dotfiles/vim_config;
  home.file.".wezterm.lua".source = ./dotfiles/weztermconfig.lua;
  home.file.".functions".source = ./dotfiles/functions;
  home.file.".hushlogin".source = ./dotfiles/hushlogin;
  home.file.".gitconfig".source = ./dotfiles/gitconfig;
  home.file.".tmux.conf".source = ./dotfiles/tmux.conf;
  home.file."./.dbt/profiles.yml".source = ./dotfiles/dbt-profiles.yml;
}
