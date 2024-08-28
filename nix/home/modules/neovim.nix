{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # TODO convert to Lua...
    extraConfig = ''
      ${builtins.readFile ./neovim/common.vim}
      ${builtins.readFile ./neovim/color.vim}
      ${builtins.readFile ./neovim/syntastic.vim}
      ${builtins.readFile ./neovim/racket.vim}
      ${builtins.readFile ./neovim/mappings.vim}
    '';

    extraLuaConfig = ''
      ${builtins.readFile ./neovim/init.lua}
    '';

    plugins = with pkgs.vimPlugins; [

      # Fuzzy Finder
      telescope-nvim
      telescope-fzf-native-nvim

      # Sessions
      vim-obsession

      # Clojure
      conjure
      vim-fireplace
      # TODO clojure-lsp ?
      # clojure-vim/clojure.vim
      vim-clojure-static
      vim-sexp
      rainbow

      # TODO orgmode ?
      # https://github.com/nvim-orgmode/orgmode/

      # Formatting
      vim-easy-align
      vim-trailing-whitespace

      # Git
      vim-gitgutter

      # Color
      vim-colors-solarized

      # Navigation
      vim-windowswap

      # Syntax
      # TODO explore syntastic -> ale ?
      vim-json
      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-nix
        p.tree-sitter-python
        p.tree-sitter-vim
      ]))
    ];
  };
}
