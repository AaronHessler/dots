return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        local logo = {
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
        }

        require('dashboard').setup {
            theme = "doom";
            config = {
                header = logo;
                vertical_center = true;
                center = {
                    { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
                };
            }
        }


    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
