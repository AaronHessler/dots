return {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        bypass_save_filetypes = { 'neo-tree', 'dashboard' },
        pre_save_cmds = {
            "Neotree close" -- Close NERDTree before saving session
        },
    }
}
