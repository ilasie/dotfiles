return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        shade_terminals = true,
        direction = 'float',
      })
    end,
  },
}
