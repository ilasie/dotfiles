local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1
vim.opt.expandtab = true

require("lazy").setup({
	spec = {
		{
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = { },
      config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
      end
    },
		{
      "nvim-tree/nvim-web-devicons",
      opts = { }
    },
		{
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = { },
    },
    {
      "romgrk/barbar.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = { },
      version = "^1.0.0"
    },
    {
      "HiPhish/rainbow-delimiters.nvim",
      submodules = false,
      main = "rainbow-delimiters.setup",
      opts = {}
    },
    
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          ensure_installed = {
            "c", "lua", "html",
            "vim", "vimdoc",
            "heex"
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true }
        })
      end
    },
    {
      "mason-org/mason.nvim",
      opts = {
        ensure_installed = {
          "lua-language-server"
        },
      },
      config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")
        local function ensure_installed()
          for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then
              p:install()
            end
          end
        end
        if mr.refresh then
          mr.refresh(ensure_installed)
        else
          ensure_installed()
        end
      end,
    },
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'default' },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },

    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "iamcco/markdown-preview.nvim",
      cmd = {
        "MarkdownPreviewToggle",
        "MarkdownPreview",
        "MarkdownPreviewStop"
      },
      ft = { "markdown" },
      build = function() vim.fn["mkdp#util#install"]() end,
    },

    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        -- if you lazy-load any plugin below, make sureto add proper 'module="..."' entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        -- `nvim-notify` is noly needed, fi you want to use the notification view.
        -- If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
      },
      opts = {}
    },
  },
	install = { colorscheme = { "catppuccin" } },
	checker = { enable = true }
})

vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--background-index",
    "--offset-encoding=utf-8",
  },
  root_markers = { ".clangd", "compile_commands.json" },
  filetypes = { "c", "cpp" },
}
vim.lsp.enable("clangd")

vim.lsp.config.rust = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
}
vim.lsp.enable("rust")
