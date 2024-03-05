#!usr/bin/env bash

export TEST=mardown_lint

find . -name "*.md,*.mdx" | xargs -n 1 markdown-link-check
