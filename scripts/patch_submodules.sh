#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 SUBMODULE_PATH LOCAL_REPOSITORY_PATH" >&2
    exit 2
}

[[ $# -eq 2 ]] || usage
[[ -d $1 && -d $2 ]] || usage

source_repo=$(realpath -- "$1")
target_repo=$(realpath -- "$2")

[[ $source_repo != "$target_repo" ]] || {
    echo "Source and destination must be different repositories." >&2
    exit 1
}

for repo in "$source_repo" "$target_repo"; do
    [[ $(git -C "$repo" rev-parse --show-toplevel 2>/dev/null) == "$repo" ]] || {
        echo "Not a Git repository root: $repo" >&2
        exit 1
    }
done

[[ -n $(git -C "$source_repo" rev-parse --show-superproject-working-tree) ]] || {
    echo "Source is not a Git submodule: $source_repo" >&2
    exit 1
}

[[ -z $(git -C "$target_repo" status --porcelain --untracked-files=all) ]] || {
    echo "Destination has existing changes; refusing to mix them with the patch." >&2
    exit 1
}

index_file=$(mktemp)
source_patch=
target_patch=
cleanup() {
    rm -f -- "$index_file"
    [[ -z $source_patch ]] || rm -f -- "$source_patch"
    [[ -z $target_patch ]] || rm -f -- "$target_patch"
}
trap cleanup EXIT

# Build a snapshot of all non-ignored changes without touching the real index.
GIT_INDEX_FILE=$index_file git -C "$source_repo" read-tree HEAD
GIT_INDEX_FILE=$index_file git -C "$source_repo" add -A

if GIT_INDEX_FILE=$index_file git -C "$source_repo" diff --cached --quiet HEAD; then
    echo "No changes to transfer." >&2
    exit 1
fi

source_patch=$(mktemp "$source_repo/.patch_submodules.XXXXXXXX.patch")
GIT_INDEX_FILE=$index_file git -C "$source_repo" diff --cached --binary --full-index HEAD > "$source_patch"

target_patch=$(mktemp "$target_repo/.patch_submodules.XXXXXXXX.patch")
mv -- "$source_patch" "$target_patch"
source_patch=

git -C "$target_repo" apply --check -- "$target_patch"
git -C "$target_repo" apply -- "$target_patch"

# The destination now has the changes. Only now discard them from the source.
git -C "$source_repo" reset --hard HEAD
git -C "$source_repo" clean -fd

echo "Transferred changes from $source_repo to $target_repo"
