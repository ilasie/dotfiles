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
    }
	},
	install = { colorscheme = { "catppuccin" } },
	checker = { enable = true }
})
