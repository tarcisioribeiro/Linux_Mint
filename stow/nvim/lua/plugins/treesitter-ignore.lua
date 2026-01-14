-- Configuração para ignorar parsers problemáticos
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Remove jsonc da lista de instalação se existir
      if opts.ensure_installed then
        opts.ensure_installed = vim.tbl_filter(function(parser)
          return parser ~= "jsonc"
        end, opts.ensure_installed)
      end

      -- Adiciona jsonc à lista de parsers ignorados
      opts.ignore_install = opts.ignore_install or {}
      table.insert(opts.ignore_install, "jsonc")

      return opts
    end,
  },
}
