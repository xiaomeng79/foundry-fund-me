-include .env
# 默认参数
DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
DEFAULT_ANVIL_ACCOUNT := 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

.PHONY: depoly-sepolia test anvil install build snapshot

anvil:
	anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast -vvvv
SEPOLIA_NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account $(SEPOLIA_ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS)

deploy-sepolia:
# forge script --chain sepolia --rpc-url ${SEPOLIA_RPC_URL} --private-key ${PRIVATE_KEY} --sender ${SENDER_ADDRESS} script/DeployFundMe.s.sol:DeployFundMe --broadcast --verify -vvvv
	forge script --chain sepolia script/DeployFundMe.s.sol:DeployFundMe $(SEPOLIA_NETWORK_ARGS)
 
fund:
	forge script script/Interactions.s.sol:FundFundMe --sender $(DEFAULT_ANVIL_ACCOUNT) $(NETWORK_ARGS)

withdraw:
	forge script script/Interactions.s.sol:WithdrawFundMe --sender $(DEFAULT_ANVIL_ACCOUNT) $(NETWORK_ARGS)

install:
	forge soldeer install
test:
	forge test
build:
	forge build
snapshot:
	forge snapshot
