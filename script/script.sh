#!/bin/sh

source .env

forge script script/deploy.s.sol --broadcast \
    --legacy --rpc-url $CONFLUX_RPC --skip-simulation --slow --verify -vvv