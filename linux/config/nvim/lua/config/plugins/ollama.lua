return {
    "nomnivore/ollama.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    opts = {
        model = "llama3.2:3b",
        prompts = {
            Analyze_File = {
                prompt = "I am analyzing this $ftype file named '$fname'. Here is the complete content:\n```$ftype\n$buf\n```\n\nMy question is: $input\n\nPlease provide a helpful response based on this file.",
                input_label = "Your question: ",
                action = "display",
            },
            Explain_File = {
                prompt = "Explain the purpose and functionality of this $ftype code:\n```$ftype\n$buf\n```",
                action = "display",
            },
            Refactor_File = {
                prompt = "Review this $ftype code and suggest improvements for readability and best practices:\n```$ftype\n$buf\n```",
                action = "display",
            },
        },
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
