#!/usr/bin/env bash

echo 11111111 | \
nchcli vm create --code_file=./nft.bc \
--from=$(nchcli keys show -a alice) \
--gas=9531375 \
--abi_file="./nft.abi" \
-b block -y


nchcli q vm call $(nchcli keys show -a alice) nch1hl0420c0uj3p8lgl6swwuvpl33xdzmxh34su83 \
name ./nft.abi

nchcli q vm call $(nchcli keys show -a alice) nch1hl0420c0uj3p8lgl6swwuvpl33xdzmxh34su83 \
symbol ./nft.abi

nchcli q vm call $(nchcli keys show -a alice) nch1hl0420c0uj3p8lgl6swwuvpl33xdzmxh34su83 \
totalSupply ./nft.abi