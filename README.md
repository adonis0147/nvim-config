# nvim-config

## Dependencies
1. [neovim](https://github.com/neovim/neovim) >= 0.12.0
2. [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)
3. [ripgrep](https://github.com/BurntSushi/ripgrep)

### Ubuntu

```shell
sudo snap install nvim --classic
npm install -g tree-sitter-cli
```

### macOS

```shell
brew install neovim ripgrep
npm install -g tree-sitter-cli
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

See [nvim/plugin/](https://github.com/adonis0147/nvim-config/blob/main/nvim/plugin/).
