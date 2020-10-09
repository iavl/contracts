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



echo 11111111 | \
nchcli vm call --from=$(nchcli keys show -a alice) \
--contract_addr=nch1hl0420c0uj3p8lgl6swwuvpl33xdzmxh34su83 \
--method=beeMint \
--abi_file="./nft.abi" \
--args="0xd0a6e6c54dbc68db5db3a091b171a77407ff7ccf nch19h2v460km5vcnt5scvl0d3qn2mnanpjkz8m7lu 8292631376851" \
--gas=9866900 -b block -y

nchcli q vm call $(nchcli keys show -a alice) nch1hl0420c0uj3p8lgl6swwuvpl33xdzmxh34su83 \
balanceOf ./nft.abi --args="nch19h2v460km5vcnt5scvl0d3qn2mnanpjkz8m7lu"

nchcli q vm call $(nchcli keys show -a alice) nch1hl0420c0uj3p8lgl6swwuvpl33xdzmxh34su83 \
ownerOf ./nft.abi --args="8292631376851"