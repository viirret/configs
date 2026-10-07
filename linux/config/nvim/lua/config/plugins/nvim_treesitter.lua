return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "c",
            "cpp",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "go",
            "rust",
            "python",
            "typescript",
            "javascript",
            "html",
            "css",
            "json",
            "yaml",
            "toml",
            "markdown",
            "markdown_inline",
            "bash",
            "nix",
        },
        auto_install = true,
        highlight = {
            enable = false,
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
