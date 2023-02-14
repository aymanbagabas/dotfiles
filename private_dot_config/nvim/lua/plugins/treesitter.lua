return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "RRethy/nvim-treesitter-endwise",
        config = function()
          require("nvim-treesitter.configs").setup({
            endwise = {
              enable = true,
            },
          })
        end,
      },
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-treesitter.configs").setup({
            autotag = {
              enable = true,
            },
          })
        end,
      },
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "help",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "python",
        "rust",
        "scss",
        "terraform",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },
}
