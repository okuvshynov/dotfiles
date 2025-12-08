return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
          "c", "cpp", "python", "lua", "vim", "vimdoc",
          "rust", "go"
      },
      highlight = { enable = true },
    })
  end,
}
