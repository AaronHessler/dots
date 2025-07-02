local M = {};

local colors = {
    bg = "#000000",
    fg = "#FFFFFF",
    super = "#47FFDD",
    red = "#FF4788",
    green = "#97FF47",
    blue = "#00CFFF",
    yellow = "#FFEA47",
    magenta = "#8367FF",
    gray = "#474747",
};

function M.colorscheme()
    vim.cmd("highlight clear")
    vim.cmd("syntax reset")

    vim.o.background = "dark"
    vim.g.colors_name = "lucid"

    local set = vim.api.nvim_set_hl

    set(0, "Comment", { fg = colors.gray, italic = true })
    set(0, "String", { fg = colors.super })
    set(0, "Type", { fg = colors.blue })
    set(0, "Statement", { fg = colors.red })
    set(0, "Function", { fg = colors.blue })
    set(0, "Constant", { fg = colors.magenta })
    set(0, "Number", { fg = colors.green })
    set(0, "Identifier", { fg = colors.green })
    set(0, "Special", { fg = colors.fg })

    set(0, "@tag.builtin", { fg = colors.red })
    set(0, "@tag.attribute", { fg = colors.green })

    set(0, "DiagnosticError", { fg = colors.red, italic = true })
    set(0, "DiagnosticWarn", { fg = colors.yellow, italic = true })
    set(0, "DiagnosticInfo", { fg = colors.blue, italic = true })
    set(0, "DiagnosticHint", { fg = colors.blue, italic = true })

    set(0, "Normal", { bg = colors.bg, fg = colors.fg })
    set(0, "Directory", { fg = colors.blue })
    set(0, "ErrorMsg", { fg = colors.red })
    set(0, "WarningMsg", { fg = colors.yellow })
    set(0, "Question", { fg = colors.blue })
    set(0, "MoreMsg", { fg = colors.blue })
    set(0, "ModeMsg", { fg = colors.super })
    set(0, "Search", { fg = colors.bg, bg = colors.super })
    set(0, "IncSearch", { fg = colors.bg, bg = colors.red })
    set(0, "CurSearch", { fg = colors.bg, bg = colors.red })
    set(0, "StatusLine", { fg = colors.super, bg = colors.bg })

    set(0, "NeoTreeGitConflict", { fg = colors.red, italic = true })
    set(0, "NeoTreeGitDeleted", { fg = colors.red, italic = true })
    set(0, "NeoTreeGitUnstaged", { fg = colors.blue, italic = true })
    set(0, "NeoTreeGitUntracked", { fg = colors.blue, italic = true })
    set(0, "NeoTreeGitRenamed", { fg = colors.magenta, italic = true })
    set(0, "NeoTreeGitModified", { fg = "#B2B2B2", italic = true })
    set(0, "NeoTreeGitStaged", { fg = colors.green })

    set(0, "NotifyERRORIcon", { fg = colors.red })
    set(0, "NotifyERRORTitle", { fg = colors.red })
    set(0, "NotifyERRORBorder", { fg = colors.red })
    set(0, "NotifyWARNIcon", { fg = colors.yellow })
    set(0, "NotifyWARNTitle", { fg = colors.yellow })
    set(0, "NotifyWARNBorder", { fg = colors.yellow })
    set(0, "NotifyINFOIcon", { fg = colors.blue })
    set(0, "NotifyINFOTitle", { fg = colors.blue })
    set(0, "NotifyINFOBorder", { fg = colors.blue })
end

return M
