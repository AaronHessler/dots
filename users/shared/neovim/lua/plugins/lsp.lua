return {
    "neovim/nvim-lspconfig",
    opts = {},
    config = function()
        vim.lsp.enable('rust_analyzer')

        vim.lsp.config("rust_analyzer", {
            settings = {
                ["rust-analyzer"] = {
                    inlayHints = {
                        bindingModeHints = {
                            enable = false,
                        },
                        chainingHints = {
                            enable = true,
                        },
                        closingBraceHints = {
                            enable = true,
                            minLines = 25,
                        },
                        closureReturnTypeHints = {
                            enable = "never",
                        },
                        lifetimeElisionHints = {
                            enable = "never",
                            useParameterNames = false,
                        },
                        maxLength = 25,
                        parameterHints = {
                            enable = true,
                        },
                        reborrowHints = {
                            enable = "never",
                        },
                        renderColons = true,
                        typeHints = {
                            enable = true,
                            hideClosureInitialization = false,
                            hideNamedConstructor = false,
                        },
                    },
                }
            }
        })

        vim.lsp.enable('ts_ls')
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('nixd')

        vim.lsp.enable('yamlls')

        vim.lsp.enable('cssls')
        vim.lsp.config('cssls', {
            filetypes = { "css", "scss", "sass" }
        })
        vim.lsp.enable('html')
        vim.lsp.enable('jsonls')

        vim.lsp.enable('tinymist')

        vim.keymap.set('n', 'K', vim.lsp.buf.hover)
    end
}
