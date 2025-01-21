-include .env



depoly-sepolia:
	forge script --chain sepolia --rpc-url ${SEPOLIA_RPC_URL} --private-key ${PRIVATE_KEY} --sender ${SENDER_ADDRESS} script/DeployFundMe.s.sol:DeployFundMe --broadcast --verify -vvvv