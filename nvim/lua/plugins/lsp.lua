return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "pyright",
                    "rust_analyzer",
                    "gopls",
                },
            })

            -- Use the new vim.lsp.enable() API
            vim.lsp.enable({ "clangd", "pyright", "rust_analyzer", "gopls" })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
                    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
                end,
            })
        end,
    },
}
