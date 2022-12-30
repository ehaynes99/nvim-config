vim.g.COMPILED_PACKER_FILE = vim.fn.stdpath('config') .. '/plugin/packer_compiled.lua'

local ensure_packer = function()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require('packer')

local compiled_packer_exists = function()
  local f = io.open(vim.g.COMPILED_PACKER_FILE, 'r')
  if f ~= nil then
    io.close(f)
    return true
  end
end

packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
  git = {
    default_url_format = 'git@github.com:%s',
  },
})

local start = function(plugins)
  return packer.startup(function(use)
    for _, plugin in pairs(plugins) do
      use(plugin)
    end
    if packer_bootstrap or not compiled_packer_exists() then
      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = { 'PackerComplete' },
        callback = function()
          require('config.plugins')
          return true
        end,
      })
      require('packer').sync()
    else
      require('config.plugins')
    end
  end)
end

return start({
  { 'wbthomason/packer.nvim', commit = '6afb67460283f0e990d35d229fd38fdc04063e0a' },

  --utilities
  { 'nvim-lua/plenary.nvim', commit = '4b7e52044bbb84242158d977a50c4cbcd85070c7' },
  { 'rcarriga/nvim-notify', commit = 'b005821516f1f37801a73067afd1cef2dbc4dfe8' },

  -- colorschemes
  { 'navarasu/onedark.nvim', commit = 'df090f9d72d43aa51dec5760c44da288b58a79b6' },
  { 'rebelot/kanagawa.nvim', commit = 'fb733c1043a462155b52cd97efd920f1dd72d33a' },
  { 'EdenEast/nightfox.nvim', commit = 'e6a0d98dc1b4751b4d999d3dffd87b1af4f4873e' },
  { 'olimorris/onedarkpro.nvim' },

  -- LSP & completion
  { 'L3MON4D3/LuaSnip', commit = '8f8d493e7836f2697df878ef9c128337cbf2bb84' },
  { 'jose-elias-alvarez/null-ls.nvim', commit = 'a0acd495f5edce6d4d5d3c6bd63d2319ccded9ed' },
  { 'hrsh7th/nvim-cmp', commit = 'b0dff0ec4f2748626aae13f011d1a47071fe9abc' },
  { 'saadparwaiz1/cmp_luasnip', commit = 'a9de941bcbda508d0a45d28ae366bb3f08db2e36' },
  { 'hrsh7th/cmp-nvim-lua', commit = 'd276254e7198ab7d00f117e88e223b4bd8c02d21' },
  { 'hrsh7th/cmp-buffer', commit = '3022dbc9166796b644a841a02de8dd1cc1d311fa' },
  { 'hrsh7th/cmp-path', commit = '447c87cdd6e6d6a1d2488b1d43108bfa217f56e1' },
  { 'hrsh7th/cmp-nvim-lsp', commit = 'affe808a5c56b71630f17aa7c38e15c59fd648a8' },
  { 'neovim/nvim-lspconfig', commit = '6eb24ef9175d1fa3c7a23e115854b1a2d923d386' },
  { 'williamboman/mason.nvim', commit = 'bfc5997e52fe9e20642704da050c415ea1d4775f' },
  { 'williamboman/mason-lspconfig.nvim', commit = '0eb7cfefbd3a87308c1875c05c3f3abac22d367c' },
  { 'nvim-treesitter/nvim-treesitter', commit = '8fe4e3625a4bfda2924518981fb9a08c0609e0c8' },
  { 'j-hui/fidget.nvim', commit = '44585a0c0085765195e6961c15529ba6c5a2a13b' },
  { 'simrat39/rust-tools.nvim', commit = '99fd1238c6068d0637df30b6cee9a264334015e9' },
  { 'folke/trouble.nvim', commit = '897542f90050c3230856bc6e45de58b94c700bbf' },
  { 'weilbith/nvim-code-action-menu', commit = '58e12501ea028ff1171f8f06ea53891f7c6e1c3f' },
  { 'jose-elias-alvarez/typescript.nvim', commit = 'ed117c35f3961785404f716a6590d99720621d34' },
  { 'Saecki/crates.nvim', commit = 'a70328ae638e20548bcfc64eb9561101104b3008' },

  -- debugger
  { 'mfussenegger/nvim-dap', commit = '6b12294a57001d994022df8acbe2ef7327d30587' },
  { 'rcarriga/nvim-dap-ui', commit = '1cd4764221c91686dcf4d6b62d7a7b2d112e0b13' },

  -- misc editor improvements
  { 'numToStr/Comment.nvim', commit = '97a188a98b5a3a6f9b1b850799ac078faa17ab67' },
  { 'petertriho/nvim-scrollbar', commit = '2cb0a0b36a45118e075699bb3a884ab819a85256' },
  { 'nvim-lualine/lualine.nvim', commit = 'b6314ac556098d7abea9bb8cf896d2e3500eca41' },
  { 'nvim-tree/nvim-web-devicons', commit = '189ad3790d57c548896a78522fd8b0d0fc11be31' },
  { 'Pocco81/auto-save.nvim', commit = '979b6c82f60cfa80f4cf437d77446d0ded0addf0' },
  { 'kyazdani42/nvim-tree.lua', commit = 'e14c2895b4f36a22001f7773244041c173dcf867' },
  { 'norcalli/nvim-colorizer.lua', commit = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6' },
  { 'mrjones2014/legendary.nvim', commit = 'b0e02000b3227e9e07adfd41565e82d166fad75e' },
  { 'chentoast/marks.nvim', commit = 'a69253e4b471a2421f9411bc5bba127eef878dc0' },
  { 'kosayoda/nvim-lightbulb', commit = '56b9ce31ec9d09d560fe8787c0920f76bc208297' },
  { 'kazhala/close-buffers.nvim', commit = '3acbcad1211572342632a6c0151f839e7dead27f' },
  { 'lukas-reineke/indent-blankline.nvim', commit = 'db7cbcb40cc00fc5d6074d7569fb37197705e7f6' },
  { 'nvim-pack/nvim-spectre', commit = 'c332c9c0574a531392818baf4020b86ba5575942' },
  { 'APZelos/blamer.nvim', commit = 'f4eb22a9013642c411725fdda945ae45f8d93181' },
  { 'gelguy/wilder.nvim', commit = '679f348dc90d80ff9ba0e7c470c40a4d038dcecf' },
  { 'Almo7aya/openingh.nvim', commit = 'cf059896995ba0e1b987f5f3b742616824901d07' },
  { 'kevinhwang91/nvim-bqf', commit = '3389264042e4590ed32ce26d7e47b17ec4e6e6d5' },
  { 'smjonas/live-command.nvim', commit = 'ce4b104ce702c7bb9fdff863059af6d47107ca61' },

  -- git
  { 'sindrets/diffview.nvim', commit = '6a82dfcb59f0af1e814f34bf8344d68afe8618ec' },

  -- session
  { 'rmagatti/auto-session', commit = 'da03666a61af32eb0f57b37f18c020a3a33a44d4' },
  { 'rmagatti/session-lens', commit = '103a45dfedc23fa6bac48dc8cdcd62fa9f98ac0c' },

  -- terminals, repls, etc.
  { 'akinsho/toggleterm.nvim', commit = '3ba683827c623affb4d9aa518e97b34db2623093' },
  { 'rafcamlet/nvim-luapad', commit = '6efe3806c6e0d9ae684d756d4d7053cbdfb562eb' },

  -- closing brackets, html tags, and end statements
  { 'windwp/nvim-ts-autotag', commit = 'fdefe46c6807441460f11f11a167a2baf8e4534b' },
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
  { 'nvim-telescope/telescope-live-grep-args.nvim', commit = '7de3baef1ec4fb77f7a8195fe87bebd513244b6a' },
  { 'stevearc/dressing.nvim', commit = '872cc4e5ea32295eb1102141a444d6d83b8f9c25' },
})
