{ config, pkgs, ... }:

{
  home.username = "tamayo";
  home.homeDirectory = "/home/tamayo";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    chez
    claude-code
    clj-kondo
    cowsay
    curl
    dig
    net-tools
    nodejs_22
    ffmpeg
    font-awesome
    freetube
    fzf
    gdu
    gimp-with-plugins
    gnome-calculator
    gnumake
    jq
    lolcat
    libreoffice-qt
    libsecret
    lua
    nix-info
    ollama-cuda
    pdfsam-basic
    pulseaudio
    python3
    ripgrep
    rpi-imager
    ruby
    signal-desktop
    silver-searcher
    simple-scan
    transmission_4-gtk
    tree
    vlc
    waybar
    wget
    yt-dlp
    zeal
  ];

  imports = [
    ./modules/bash.nix
    ./modules/browsers.nix
    ./modules/clojure
    ./modules/colors
    ./modules/direnv.nix
    ./modules/hyprland.nix
    ./modules/ledger.nix
    ./modules/neovim.nix
    ./modules/nix.nix
    ./modules/git.nix
    ./modules/plasma.nix
    ./modules/tmux.nix
  ];

  home.activation = {
    hyprland = ''
      mkdir -p ~/.config/hypr
      ln -sf ~/dotfiles/config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua
    '';

    waybar = ''
      ln -s ~/dotfiles/config/waybar ~/.config/waybar
    '';

    agents = ''
      mkdir -p ~/.config/mcp
      cat > ~/.config/mcp/mcp.json <<EOF
      {
        "mcpServers": {
          "clojure-mcp": {
            "command": "${pkgs.bashInteractive}/bin/bash",
            "args": [
              "-c",
              "clojure -Tmcp start :port 7888"
            ]
          }
        }
      }
      EOF

      dotfiles_dir=~/dotfiles/nix/home

      # https://agentsstandard.com/
      ln -sf $dotfiles_dir/agents ~/.agents

      ln -sf $dotfiles_dir/pi/agent/models.json ~/.pi/agent/models.json
      ln -sf $dotfiles_dir/pi/agent/config.json ~/.pi/agent/config.json

      mkdir -p ~/.pi/agent/extensions
      ln -sf $dotfiles_dir/pi/agent/extensions/emoji-spinner/index.ts ~/.pi/agent/extensions/emoji-spinner/index.ts
    '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "claude-code"
    "discord"
    "typora"
    # TODO replace these vim ones?
    "vim-solarized8"
    "vim-trailing-whitespace"
    "vim-windowswap"
    # For ollama-cuda
    "cuda_cccl"
    "cuda_cudart"
    "cuda_nvcc"
    "libcublas"
  ];

  # Ignore project dependency files in syncs.
  # These can be restored easily, and so aren't worth the noise.
  home.file."projects/.stignore".source = ./syncthing/projects.stignore;

  home.stateVersion = "23.11";
}
