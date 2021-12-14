#!/usr/bin/env bash


usage() {
	echo "
  usage: ./atom-config.sh <import|export|unimport> [--no-packages]
  this command offers a set of utilities to sync the configuration files and/or installed packages of the Atom code editor.

	import
		saves a backup of any existing .cson files under the atom configuration directory, and replaces the originals with configuration files from the local repository.
		also, unless --no-packages is used, installs all packages found on the packages list file generated with the export command.

	export
		copies all .cson files under the atom configuration directory, as well as a generated file with the list of installed packages, into the local repository.

	unimport
		restore configuration files from saved backup, after an import.
		beware - this will override any existing atom configuration, and is irreversible.

"
}

main() {
	validate "$@"

	local action
	local temp_dir

	local source_dir="$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )"
	local root_dir="$source_dir"'/..'
	local etc_dir="$root_dir"'/etc'

	temp_dir="$(create_temp_dir)"
	cleanup_dir_on_exit "$temp_dir"

	if [[ -n $1 ]] && is_available "cmd_$1"; then
		action="$1"; shift
		cmd_${action} "$etc_dir" "$temp_dir" "$@"
	fi
}


cmd_import() {
	local etc_dir="$1"
	local temp_dir="$2"
	cp -r "$etc_dir"/* "$temp_dir"
	backup_settings
	import_settings "$temp_dir"
	import_packages "$temp_dir"
}

cmd_unimport() {
	restore_settings
}

cmd_export() {
	local etc_dir="$1"
	local temp_dir="$2"
	export_settings "$temp_dir"
	export_packages "$temp_dir"
	cp -r "$temp_dir"/* "$etc_dir"
}


import_settings() {
	local source_dir="$1"
	cp "$source_dir"/*.cson ~/.atom/
}

export_settings() {
	local target_dir="$1"
	cp ~/.atom/*.	cson "$target_dir"
}

import_packages() {
	local input_dir="$1"
	apm install --packages-file "$input_dir"'/package.list'
}

export_packages() {
	local output_dir="$1"
	apm list --installed --bare > "$output_dir"'/package.list'
}

backup_settings() {
	for f in ~/.atom/*.cson; do
    mv -- "$f" "${f}.backup"
	done
}

restore_settings() {
	for f in ~/.atom/*.cson.backup; do
		mv -- "$f" "${f%.backup}"
	done
}

create_temp_dir() {
	mktemp -d 2>/dev/null || mktemp -d -t 'atom-config-export'
}

cleanup_dir_on_exit() {
	trap 'rm -rf '"$@"' >/dev/null 2>&1' EXIT
}

validate() {
	if [[ -z $1 ]]; then
		usage
		exit 1
	fi
}

is_available() {
	type "$1" >/dev/null 2>&1
}


main "$@"
