return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module "neo-tree"
    ---@type neotree.Config?
    config = function()
        vim.keymap.set("n", "<C-d>", "<cmd>Neotree toggle right<CR>")
        require("neo-tree").setup({
            buffers = {
                follow_current_file = {
                    enabled = true,
                }
            },
            window = {
                mappings = {
                    ["o"] = "open",
                    ["oc"] = "noop",
                    ["od"] = "noop",
                    ["og"] = "noop",
                    ["om"] = "noop",
                    ["on"] = "noop",
                    ["os"] = "noop",
                    ["ot"] = "noop",
                    ["O"] = function(state)
                        local node = state.tree:get_node()
                        if node and node.path then
                            vim.fn.system({ 'sushi', node.path })
                        end
                    end,
                },
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    enabled = true,
                }
            }
        })
    end
}
