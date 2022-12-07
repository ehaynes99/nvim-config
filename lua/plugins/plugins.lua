return {
  { 'wbthomason/packer.nvim', commit = '6afb67460283f0e990d35d229fd38fdc04063e0a' },

  --utilities
  { 'nvim-lua/plenary.nvim', commit = '4b7e52044bbb84242158d977a50c4cbcd85070c7' },

  -- colorschemes
  { 'navarasu/onedark.nvim', commit = 'df090f9d72d43aa51dec5760c44da288b58a79b6' },
  { 'rebelot/kanagawa.nvim', commit = 'fb733c1043a462155b52cd97efd920f1dd72d33a' },
  { 'EdenEast/nightfox.nvim', commit = 'e6a0d98dc1b4751b4d999d3dffd87b1af4f4873e' },

  -- LSP & completion
  { 'L3MON4D3/LuaSnip', commit = '8f8d493e7836f2697df878ef9c128337cbf2bb84' },
  { 'jose-elias-alvarez/null-ls.nvim', commit = 'c0c19f32b614b3921e17886c541c13a72748d450' },
  { 'RRethy/vim-illuminate', commit = 'a2e8476af3f3e993bb0d6477438aad3096512e42' },
  { 'hrsh7th/nvim-cmp', commit = 'b0dff0ec4f2748626aae13f011d1a47071fe9abc' },
  { 'saadparwaiz1/cmp_luasnip', commit = 'a9de941bcbda508d0a45d28ae366bb3f08db2e36' },
  { 'hrsh7th/cmp-nvim-lua', commit = 'd276254e7198ab7d00f117e88e223b4bd8c02d21' },
  { 'hrsh7th/cmp-buffer', commit = '3022dbc9166796b644a841a02de8dd1cc1d311fa' },
  { 'hrsh7th/cmp-path', commit = '447c87cdd6e6d6a1d2488b1d43108bfa217f56e1' },
  { 'hrsh7th/cmp-nvim-lsp', commit = 'affe808a5c56b71630f17aa7c38e15c59fd648a8' },
  { 'neovim/nvim-lspconfig', commit = 'f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda' },
  { 'williamboman/mason.nvim', commit = 'bfc5997e52fe9e20642704da050c415ea1d4775f' },
  { 'williamboman/mason-lspconfig.nvim', commit = '0eb7cfefbd3a87308c1875c05c3f3abac22d367c' },
  { 'nvim-treesitter/nvim-treesitter', commit = '8fe4e3625a4bfda2924518981fb9a08c0609e0c8' },
  { 'j-hui/fidget.nvim', commit = '44585a0c0085765195e6961c15529ba6c5a2a13b' },

  -- debugger
  { 'mfussenegger/nvim-dap', commit = '6b12294a57001d994022df8acbe2ef7327d30587' },
  { 'rcarriga/nvim-dap-ui', commit = '1cd4764221c91686dcf4d6b62d7a7b2d112e0b13' },

  -- misc editor improvements
  { 'numToStr/Comment.nvim', commit = '97a188a98b5a3a6f9b1b850799ac078faa17ab67' },
  { 'petertriho/nvim-scrollbar', commit = '2cb0a0b36a45118e075699bb3a884ab819a85256' },
  { 'nvim-lualine/lualine.nvim', commit = 'b6314ac556098d7abea9bb8cf896d2e3500eca41' },
  { 'nvim-tree/nvim-web-devicons', commit = '189ad3790d57c548896a78522fd8b0d0fc11be31' },
  { 'akinsho/bufferline.nvim', commit = '4ecfa81e470a589e74adcde3d5bb1727dd407363' },
  { 'Pocco81/auto-save.nvim', commit = '979b6c82f60cfa80f4cf437d77446d0ded0addf0' },
  { 'kyazdani42/nvim-tree.lua', commit = 'f8489c992998e1e1b45aec65bdb9615e5cd59a61' },
  { 'norcalli/nvim-colorizer.lua', commit = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6' },
  { 'mrjones2014/legendary.nvim', commit = 'b0e02000b3227e9e07adfd41565e82d166fad75e' },
  { 'chentoast/marks.nvim', commit = 'a69253e4b471a2421f9411bc5bba127eef878dc0' },
  { 'ellisonleao/glow.nvim', commit = '20d1cd087f8728f21a048a3b6259f6177237b39e' },
  { 'kosayoda/nvim-lightbulb', commit = '56b9ce31ec9d09d560fe8787c0920f76bc208297' },
  { 'kazhala/close-buffers.nvim', commit = '3acbcad1211572342632a6c0151f839e7dead27f' },
  { 'lukas-reineke/indent-blankline.nvim', commit = 'db7cbcb40cc00fc5d6074d7569fb37197705e7f6' },
  { 'nvim-pack/nvim-spectre', commit = 'c332c9c0574a531392818baf4020b86ba5575942' },
  -- makes lsp actions a dialog
  {
    'weilbith/nvim-code-action-menu',
    commit = '58e12501ea028ff1171f8f06ea53891f7c6e1c3f',
    cmd = 'CodeActionMenu',
  },

  -- git
  { 'sindrets/diffview.nvim', commit = '6a82dfcb59f0af1e814f34bf8344d68afe8618ec' },

  -- session
  { 'rmagatti/auto-session', commit = 'da03666a61af32eb0f57b37f18c020a3a33a44d4' },
  { 'rmagatti/session-lens', commit = '103a45dfedc23fa6bac48dc8cdcd62fa9f98ac0c' },

  -- terminals, repls, etc.
  { 'akinsho/toggleterm.nvim', commit = '3ba683827c623affb4d9aa518e97b34db2623093' },
  { 'rafcamlet/nvim-luapad', commit = '6efe3806c6e0d9ae684d756d4d7053cbdfb562eb' },

  -- closing brackets, html tags, and end statements
  {
    'windwp/nvim-ts-autotag',
    commit = 'fdefe46c6807441460f11f11a167a2baf8e4534b',
    requires = { 'nvim-treesitter' },
  },
  { 'windwp/nvim-autopairs', commit = '99f696339266c22e7313d6a85a95bd538c3fc226' },
  { 'RRethy/nvim-treesitter-endwise', commit = '0cf4601c330cf724769a2394df555a57d5fd3f34' },
  { 'kylechui/nvim-surround', commit = '6b45fbffdabb2d8cd80d310006c92e59cec8fd74' },

  -- file/text search - note, requires `ripgrep` and `fd`
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    commit = '65c0ee3d4bb9cb696e262bca1ea5e9af3938fc90',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  },
  { 'nvim-telescope/telescope.nvim', commit = '76ea9a898d3307244dce3573392dcf2cc38f340f' },
  { 'stevearc/dressing.nvim', commit = '872cc4e5ea32295eb1102141a444d6d83b8f9c25' },
}
