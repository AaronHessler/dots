return {
    'chomosuke/typst-preview.nvim',
    lazy = false, -- or ft = 'typst'
    version = '1.*',
    opts = {
        dependencies_bin = {
            ["tinymist"] = nil,
        }
    }, -- lazy.nvim will implicitly calls `setup {}`
}
