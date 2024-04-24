#!/bin/bash


cd $(dirname $0)

if command -v hx >/dev/null 2>&1; then
    echo -e "\033[33m- [Warn] hx command alreally exist\033[0m"
else
    check_os=$(rpm -qa 2>/dev/null | grep release | grep el9.x86_64)
    if [ -n "$check_os" ]; then
        wget https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/h/helix-24.03-2.el9.x86_64.rpm
        rpm -ivh helix-24.03-2.el9.x86_64.rpm
    else
        if [ -e helix.24.3.tar.gz ]; then
            tar -xf helix.24.3.tar.gz --strip-components 1 -C /usr/
        fi
    fi
fi

if ! command -v hx >/dev/null 2>&1; then
    echo -e "\033[33m- [Err] hx command install failed\033[0m"
    exit 1
fi

if command -v rust-analyzer  >/dev/null 2>&1; then
    echo -e "\033[33m- [Warn] rust-analyzer command alreally exist\033[0m"
else
    if [ ! -e rust-analyzer-x86_64-unknown-linux-gnu.gz ]; then
        gunzip rust-analyzer-x86_64-unknown-linux-gnu.gz
        wget https://github.com/rust-lang/rust-analyzer/releases/download/2024-01-29/rust-analyzer-x86_64-unknown-linux-gnu.gz
    fi

    if [ -e rust-analyzer-x86_64-unknown-linux-gnu.gz ]; then
        gunzip rust-analyzer-x86_64-unknown-linux-gnu.gz
        chmod +x rust-analyzer-x86_64-unknown-linux-gnu
        [ ! -d ~/.cargo/bin ] && mkdir -p ~/.cargo/bin
        mv rust-analyzer-x86_64-unknown-linux-gnu ~/.cargo/bin/rust-analyzer
    fi
fi

if ! command -v rust-analyzer >/dev/null 2>&1; then
    echo -e "\033[33m- [Err] rust-analyzer command install failed\033[0m"
    exit 1
fi

if [ ! -d ~/.config/helix ]; then
    mkdir -p ~/.config/helix
fi
cp -f helix-vim/config.toml ~/.config/helix/

cp -f ./languages.toml ~/.config/helix/

echo -e "\033[32m- [Info] Install successfully...\033[0m"

exit 0
