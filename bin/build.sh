#!/usr/bin/env bash


main() {
	local temp_dir

	local source_dir="$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )"
	local root_dir="$source_dir"'/..'
	local build_dir="$root_dir"'/etc'

	temp_dir="$(create_temp_dir)"
	cleanup_dir_on_exit "$temp_dir"

	copy_settings "$temp_dir"
	generate_package_list "$temp_dir"

	cp -r "$temp_dir"/* "$build_dir"
}

copy_settings() {
	local output_dir="$1"
	cp ~/.atom/*.cson "$output_dir"
}

generate_package_list() {
	local output_dir="$1"
	apm list --installed --bare > "$output_dir"'/package.list'
}

create_temp_dir() {
	mktemp -d 2>/dev/null || mktemp -d -t 'atom-config-build'
}

cleanup_dir_on_exit() {
	trap 'rm -rf '"$@"' >/dev/null 2>&1' EXIT
}


main
