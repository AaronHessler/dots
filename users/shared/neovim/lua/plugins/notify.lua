return {
    "rcarriga/nvim-notify",
    config = function()
        vim.notify = require("notify")

        vim.keymap.set("n", "<C-x>", function()
            vim.notify.dismiss({ silent = true, pending = true })
        end, { desc = "Dismiss notifications" })
    end
}
