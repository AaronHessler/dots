return {
    "neovim/nvim-lspconfig",
    opts = {},
    config = function()
        vim.lsp.enable('rust_analyzer')
        vim.lsp.enable('ts_ls')
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('nixd')

        vim.lsp.enable('cssls')
        vim.lsp.enable('html')
        vim.lsp.enable('jsonls')

        vim.keymap.set('n', 'K', vim.lsp.buf.hover)
    end
}
