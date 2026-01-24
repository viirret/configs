-- cmp keys
local M = {}

function M.get_mappings()
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    return cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<C-Space>"] = cmp.mapping.complete(),

        -- Smart Tab: confirm completion, expand/jump snippet, or insert tab
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm { select = true }
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        -- Shift-Tab to jump backward in snippet placeholders
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }
end

return M
