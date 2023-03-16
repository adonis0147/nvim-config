#!/usr/bin/env bash

set -e

function log() {
	local level="${1}"
	local message="${2}"
	local date
	date="$(date +'%Y-%m-%d %H:%M:%S')"
	if [[ "${level}" == 'INFO' ]]; then
		level="[\033[32;1m ${level}  \033[0m]"
	elif [[ "${level}" == 'WARNING' ]]; then
		level="[\033[33;1m${level}\033[0m]"
	elif [[ "${level}" == 'ERROR' ]]; then
		level="[\033[31;1m ${level} \033[0m]"
	fi
	echo -e "${level} ${date} - ${message}"
}

function log_info() {
	local message="${1}"
	log 'INFO' "${message}"
}

function log_warning() {
	local message="${1}"
	log 'WARNING' "${message}"
}

function log_error() {
	local message="${1}"
	log 'ERROR' "${message}"
	exit 1
}

function install_nvim_config() {
	log_info 'Installing nvim configuration...'
	local install_path="${HOME}/.config/nvim"
	if [[ -d "${install_path}" ]]; then
		mkdir -p 'backup'
		mv "${install_path}" "backup/nvim.$(date +'%Y%m%d%H%M%S')"
	fi
	mkdir -p "${HOME}/.config"
	pushd nvim >/dev/null
	ln -snf "$(pwd)" "${install_path}"
	popd >/dev/null
	log_info 'Success!'
}

function setup() {
	install_nvim_config
	log_info 'Completed!'
}

setup "${@}"
