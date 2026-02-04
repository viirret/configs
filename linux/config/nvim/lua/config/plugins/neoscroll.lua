return {
    "karb94/neoscroll.nvim",
    config = function()
        require("neoscroll").setup {
            performance_mode = true,
            easing_function = "quadratic",
            hide_cursor = false,
            stop_eof = true,
        }
    end,
}
