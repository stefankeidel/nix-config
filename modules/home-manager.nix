{
  config,
  inputs,
  pkgs,
  lib,
  home-manager,
  userConfig,
  ...
}:

let
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
in {
  imports = [
    ./dock
  ];
  
  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;

    users.${userConfig.name} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      home = {
        # enableNixpkgsReleaseCheck = false;
        # common packages for all systems

        # minimal packages, can also be used in headless systems
        packages = pkgs.callPackage ./min-packages.nix {inherit inputs;};

        # this is internal compatibility configuration
        # for home-manager, don't change this!
        stateVersion = "23.05";

        sessionVariables = {
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

        file.".vimrc".source = ../dotfiles/vim_config;
        file.".wezterm.lua".source = ../dotfiles/weztermconfig.lua;
        file.".functions".source = ../dotfiles/functions;
        file.".hushlogin".source = ../dotfiles/hushlogin;
        file.".gitconfig".source = ../dotfiles/gitconfig;
        file.".tmux.conf".source = ../dotfiles/tmux.conf;
        file."./.dbt/profiles.yml".source = ../dotfiles/dbt-profiles.yml;
        file."./.colima/_templates/default.yaml".source = ../dotfiles/colima.yaml;
        file."emacs-launcher.command".source = myEmacsLauncher;
      };

      programs = {
        home-manager.enable = true;
        bat.enable = true;
        broot.enable = true;
        tmux.enable = true;
        jq.enable = true;
        direnv.enable = true;

        zsh = {
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
            pythonShell = "nix develop ~/code/nix-config/#python311 -c $SHELL";
            k = "kubectl -n data";
            h = "helm --namespace data";
          };

          history = {
            size = 1000000;
          };

          oh-my-zsh = {
            enable = true;
            plugins = ["git" "z" "terraform" "poetry"];
          };
        };

        fzf = {
          enable = true;
          enableZshIntegration = true;
        };
      }; # import ../shared/home-manager.nix { inherit config pkgs lib; };
    };
  };

    # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "${pkgs.wezterm}/Applications/WezTerm.app/"; }
    { path = "/Applications/Firefox.app/"; }
    { path = "/System/Applications/Calendar.app/"; }
    { path = "/Applications/Microsoft\ Outlook.app/"; }
    { path = "/Applications/Microsoft\ Teams.app/"; }
    { path = "${pkgs.element-desktop}/Applications/Element.app/"; }
    { path = "/System/Applications/Mail.app/"; }
    { path = "${pkgs.jetbrains.datagrip}/Applications/DataGrip.app/"; }
    { path = "/System/Applications/Notes.app/"; }
    { path = "${pkgs.signal-desktop}/Applications/Signal.app/"; }
    { path = "${pkgs.spotify}/Applications/Spotify.app/"; }
    { path = "/System/Applications/System\ Settings.app/"; }

    # {
    #   path = toString myEmacsLauncher;
    #   section = "others";
    # }
    # { path = "/System/Applications/News.app/"; }
    # { path = "/System/Applications/Photos.app/"; }
    # { path = "/System/Applications/Photo Booth.app/"; }
    # { path = "/System/Applications/TV.app/"; }
    # { path = "/System/Applications/Home.app/"; }
    # # {
    # #   path = toString myEmacsLauncher;
    # #   section = "others";
    # # }
    # {
    #   path = "${config.users.users.${user}.home}/.local/share/";
    #   section = "others";
    #   options = "--sort name --view grid --display folder";
    # }
    # {
    #   path = "${config.users.users.${user}.home}/.local/share/downloads";
    #   section = "others";
    #   options = "--sort name --view grid --display stack";
    # }
  ];
}
