#!/bin/bash

# Get the files SHA1 hash
hash_sha1() {
    local file="$1"
    sha1sum "$file" | awk '{print $1}'
}

# Get the files SHA256 hash
hash_sha256() {
    local file="$1"
    sha256sum "$file" | awk '{print $1}'
}

# Get the files MD5 hash
hash_md5() {
    local file="$1"
    md5sum "$file" | awk '{print $1}'
}