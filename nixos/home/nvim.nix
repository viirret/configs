{ config, pkgs, lib, ... }:

{
  home.activation.removeOldNeovimConfig = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    rm -rf "${config.home.homeDirectory}/.config/nvim"
  '';
  home.activation.linkNeovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn "${config.home.homeDirectory}/.dotfiles/linux/.config/nvim" "${config.home.homeDirectory}/.config"
  '';

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      # Telescope dependencies
      ripgrep

      # LSP servers
      clang-tools
      nixd
      vtsls
      lua-language-server
      python3Packages.python-lsp-server
      rust-analyzer
      nil
      marksman
      cmake-language-server
      bash-language-server
      texlab
      gopls

      # Formatters
      black
      ruff
      stylua
      prettier
      cmake-format
      gofumpt
      rustfmt
      shfmt
    ];
  };

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

}
