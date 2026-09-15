return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function()
        require "nvim-treesitter-textobjects".setup({
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V',  -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                },

                include_surrounding_whitespace = false,
            },
        })
        local select = require("nvim-treesitter-textobjects.select")

        -- Simple mappings (string query)
        vim.keymap.set({ "x", "o" }, "af", function()
            select.select_textobject("@function.outer", "textobjects")
        end, { desc = "Select outer part of a function" })

        vim.keymap.set({ "x", "o" }, "if", function()
            select.select_textobject("@function.inner", "textobjects")
        end, { desc = "Select inner part of a function" })

        vim.keymap.set({ "x", "o" }, "ac", function()
            select.select_textobject("@class.outer", "textobjects")
        end, { desc = "Select outer part of a class region" })

        -- Mapping with explicit description
        vim.keymap.set({ "x", "o" }, "ic", function()
            select.select_textobject("@class.inner", "textobjects")
        end, { desc = "Select inner part of a class region" })

        -- Mapping using a different query group (e.g., locals.scm)
        vim.keymap.set({ "x", "o" }, "as", function()
            select.select_textobject("@local.scope", "locals")
        end, { desc = "Select language scope" })
    end
}
