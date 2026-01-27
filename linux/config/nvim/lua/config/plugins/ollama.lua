return {
    "nomnivore/ollama.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    opts = {
        model = "llama3.2:3b",
    },

    config = function(_, opts)
        local ok, ollama = pcall(require, "ollama")
        if ok then
            ollama.setup(opts)
        else
            vim.notify("Failed to load ollama.nvim", vim.log.levels.ERROR)
        end
    end,
}
