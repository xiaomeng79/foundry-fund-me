-include .env

.PHONY: depoly-sepolia test

depoly-sepolia:
	forge script --chain sepolia --rpc-url ${SEPOLIA_RPC_URL} --private-key ${PRIVATE_KEY} --sender ${SENDER_ADDRESS} script/DeployFundMe.s.sol:DeployFundMe --broadcast --verify -vvvv

install:
	forge soldeer install
test:
	forge test
build:
	forge build
snapshot:
	forge snapshot
