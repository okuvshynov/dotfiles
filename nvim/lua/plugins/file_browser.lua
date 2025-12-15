return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ft", "<cmd>Telescope file_browser<cr>", desc = "File browser/File Tree" },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        file_browser = {
          depth = 1,
          grouped = true,  -- directories first, then files
        }
      }
    })
  end,
}

