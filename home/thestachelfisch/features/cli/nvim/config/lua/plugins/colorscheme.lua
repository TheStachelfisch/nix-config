return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local C = require("nightfox.lib.color")

      -- default bg color for Carbonfox
      local bg = C("#161616");

      require("nightfox").setup({
        options = {
          dim_inactive = true,
          styles = {
            comments = "italic",
            keywords = "italic",
          },
        },
        palettes = {
          carbonfox = {
            bg0 = bg:brighten(-4):to_css(),
            bg1 = bg:brighten(-6):to_css(),
          },
        },
        groups = {
          all = {
            Conditional = { style = "italic" },
            Repeat = { style = "italic" },
            PreProc = { style = "italic" },
            ["@parameter"] = { style = "underline" },
            ["@keyword.function"] = { style = "italic" },
            ["@keyword.operator"] = { style = "italic" },
            ["@keyword.operator.new"] = { style = "italic" },
            ["@keyword.operator.borrow.and.rust"] = { style = "italic" },
            ["@function.builtin"] = { style = "bold" },
            ["@variable.builtin"] = { style = "bold" },
          },
        },
      });

      vim.cmd([[colorscheme carbonfox]])
      vim.o.winborder = 'rounded'
    end,
  },
}
