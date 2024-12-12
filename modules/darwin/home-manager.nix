{ config, pkgs, lib, home-manager, userConfig, ... }:

{
  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    
    users.${userConfig.name} = { pkgs, config, lib, ... }:{
      home = {
        # enableNixpkgsReleaseCheck = false;
        # packages = pkgs.callPackage ./packages.nix {};
        # file = lib.mkMerge [
        #   sharedFiles
        #   additionalFiles
        #   { "emacs-launcher.command".source = myEmacsLauncher; }
        # ];

        # this is internal compatibility configuration 
        # for home-manager, don't change this!
        stateVersion = "23.05";

        packages = with pkgs; [
          pkgs.alejandra
          pkgs.azure-cli
          pkgs.colima
          pkgs.coreutils
          pkgs.curl
          pkgs.docker-buildx
          pkgs.docker-client
          pkgs.dua
          pkgs.eza
          pkgs.git
          pkgs.httpie
          pkgs.jetbrains.datagrip
          pkgs.jless
          pkgs.k9s
          pkgs.kalker
          pkgs.kubectl
          pkgs.kubelogin
          pkgs.kubernetes-helm
          pkgs.minikube
          pkgs.morph
          pkgs.mosh
          pkgs.netcat-gnu
          pkgs.nix-direnv
          pkgs.nmap
          pkgs.nodejs
          pkgs.pv
          pkgs.pwgen
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
          pkgs.zoom-us
        ];

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

          file.".vimrc".source = ../../dotfiles/vim_config;
          file.".wezterm.lua".source = ../../dotfiles/weztermconfig.lua;
          file.".functions".source = ../../dotfiles/functions;
          file.".hushlogin".source = ../../dotfiles/hushlogin;
          file.".gitconfig".source = ../../dotfiles/gitconfig;
          file.".tmux.conf".source = ../../dotfiles/tmux.conf;
          file."./.dbt/profiles.yml".source = ../../dotfiles/dbt-profiles.yml;
          file."./.colima/_templates/default.yaml".source = ../../dotfiles/colima.yaml;
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

        fzf = {
          enable = true;
          enableZshIntegration = true;
        };
        
      };# import ../shared/home-manager.nix { inherit config pkgs lib; };
    };
  };
}
