return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      hijack_netrw_behavior = "open_default",

      buffers = {
        follow_current_file = {
          enabled = true,
          group_empty_dirs = true,
        },
      },

      sources = {
        "filesystem",
        "buffers",
        "git_status",
      }
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Do live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Search buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Search help tags" },
    }
  },
  {
    "ThePrimeagen/vim-be-good"
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("telescope").load_extension("projects")
      require("project_nvim").setup({
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".sln" },
      })
    end
  }
}
