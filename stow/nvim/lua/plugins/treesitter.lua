return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Desabilitar instalação automática do jsonc se houver problemas
      auto_install = false,
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        -- Comentar jsonc temporariamente se continuar dando erro
        -- "jsonc",
      },
    },
  },
}
