#!/usr/bin/env zsh

# This scripts can be used to create flat files which can be directly imported on Remix if needed.
echo "Clearing existing flats"
if [ -d dist ]; then
    rm -rf dist
fi

mkdir dist
# AdapterRegistr
echo "Flattening # AdapterRegistry contract"
npx hardhat flatten ./contracts/AdapterRegistry.sol > ./dist/AdapterRegistry.sol