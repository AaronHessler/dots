return {
    "L3MON4D3/LuaSnip",
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    build = "make install_jsregexp",
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        local ls = require("luasnip")
        ls.filetype_extend("typescriptreact", { "javascriptreact", "html" })
        ls.filetype_extend("javascriptreact", { "html" }) --require("luasnip").filetype_extend("typescriptreact", { "javascriptreact" })
    end
}
