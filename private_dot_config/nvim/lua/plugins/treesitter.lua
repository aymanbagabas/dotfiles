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
      ---@diagnostic disable-next-line: missing-parameter
      vim.list_extend(opts.ensure_installed, {
        "c",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
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
        "toml",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },
}
