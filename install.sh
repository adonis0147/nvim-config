#!/usr/bin/env bash

set -e

function log() {
  local level="${1}"
  local message="${2}"
  local date
  date="$(date +'%Y-%m-%d %H:%M:%S')"
  if [[ "${level}" == 'INFO' ]]; then
    level="[\033[32;1m${level}\033[0m] "
  elif [[ "${level}" == 'ERROR' ]]; then
    level="[\033[31;1m${level}\033[0m]"
  fi
  echo -e "${level} ${date} - ${message}"
}

function log_info() {
  local message="${1}"
  log 'INFO' "${message}"
}

function log_error() {
  local message="${1}"
  log 'ERROR' "${message}"
}

function install_packer() {
  log_info 'Installing packer.nvim...'
  local install_path="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
  if [[ ! -d "${install_path}" ]]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  fi
  log_info 'Success!'
}

function install_nvim_config() {
  log_info 'Installing nvim configuration...'
  local install_path="${HOME}/.config/nvim"
  if [[ -d "${install_path}" ]]; then
    mkdir -p 'backup'
    mv "${install_path}" "backup/nvim.$(date +'%Y%m%d%H%M%S')"
  fi
  pushd nvim > /dev/null
  ln -snf "$(pwd)" "${install_path}"
  popd > /dev/null
  log_info 'Success!'
}

function install_packages() {
  log_info 'Installing packages...'
  nvim -c 'autocmd! User PackerCompileDone :qa' -c ':PackerSync'
  log_info 'Success!'
}

function setup() {
  install_packer
  install_nvim_config
  install_packages
  log_info 'Completed.'
}

setup "${@}"
