return {
  
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      }
    }
  },

  {
    'saghen/blink.cmp',
    version = '1.*',

    -- V2
    -- dependencies = { 'saghen/blink.lib' },
    -- build = function() require('blink.cmp').build():wait(60000) end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      fuzzy = { implementation = "rust" }
    },
  }

}
