# nvim-config

## Dependencies
1. [neovim](https://github.com/neovim/neovim) >= 0.8
2. [ripgrep](https://github.com/BurntSushi/ripgrep)

### Ubuntu

```shell
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim ripgrep
```

### MacOS

```shell
brew install neovim ripgrep
```

## Installation

```shell
git clone https://github.com/adonis0147/nvim-config "${HOME}/.config/nvim-config"
./install.sh
```

## Key Bindings

See [nvim/lua/key_bindings.lua](https://github.com/adonis0147/nvim-config/blob/main/nvim/lua/key_bindings.lua).

* `<leader>` : `<space>`
* `<leader>e` : Quit
* `<leader>E` : Quit all without saving
* Moving between windows
    * `<ctrl-h>` : Left
    * `<ctrl-j>` : Down
    * `<ctrl-k>` : Up
    * `<ctrl-l>` : Right
* Moving between tabs 
    * `<leader>n` : Previous tab
    * `<leader>m` : Next tab
* `<F5>` : Build by `make` command
* `<F9>` : Build and run (only available for a single source code file)

## Plugins Management

Use [lazy.nvim](https://github.com/folke/lazy.nvim) to manage plugins.

See [nvim/lua/plugins/plugins.lua](https://github.com/adonis0147/nvim-config/blob/main/nvim/lua/plugins/plugins.lua).
