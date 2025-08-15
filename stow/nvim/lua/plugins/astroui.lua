-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    colorscheme = "dracula",
    highlights = {
      init = function()
        local set_hl = vim.api.nvim_set_hl
        set_hl(0, "Normal", { bg = "none" })
        set_hl(0, "NormalNC", { bg = "none" })
        set_hl(0, "NormalFloat", { bg = "none" })
        set_hl(0, "FloatBorder", { bg = "none" })
        set_hl(0, "SignColumn", { bg = "none" })
      end,
    },
    options = {
      relativenumber = false,
      number = true,
    },
    icons = {
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
