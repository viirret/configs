local builder = require("config.plugins.lsp.lspbuilder")

local M = {}

function M.setup(capabilities, on_attach)
	builder.build({
		name = "lua_ls",
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		capabilities = capabilities,
		on_attach = on_attach,
		root_patterns = { ".luarc.json", ".git", "init.lua" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	})
end

return M
