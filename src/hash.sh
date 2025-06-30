#!/bin/bash

hash_sha1() {
    local file="$1"
    sha1sum "$file" | awk '{print $1}'
}

hash_sha256() {
    local file="$1"
    sha256sum "$file" | awk '{print $1}'
}

hash_md5() {
    local file="$1"
    md5sum "$file" | awk '{print $1}'
}