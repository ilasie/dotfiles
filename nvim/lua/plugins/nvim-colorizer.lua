return {
  {
    "norcalli/nvim-colorizer.lua",
    config=function()
      require("colorizer").setup({"*"}, {
        RRGGBB = true
      })
    end
  },
}
