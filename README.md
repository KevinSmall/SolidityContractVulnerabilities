# Solidity Contract Vulnerability Demos
Demos of Solidity Contract vulnerabilities, see also https://consensys.github.io/smart-contract-best-practices/known_attacks/.

# Reentrancy
Reentrancy can happen when your contract function passes control to an external contract. It is possible that the external contract does something you don't expect, like calling your contract function again.

To demonstrate the problem use e.g. [Remix](https://remix.ethereum.org/) and use the contracts in folder `ReentrancySingleFunction`.

### Setup
 1. Deploy the victim contract `ReentrancyVictim.sol`. Note the deployed contract address.
 2. Deploy the attacker contract `ReentrancyAttackerToken.sol`. Note the deployed contract address. The attacker contract is pretending to be a regular ERC20 contract (it implements the `IErc20` interface), but really it is going to attack the victim.
 3. The victim must be configured to point to the attacking ERC20 contract. Use e.g. Remix to make a transaction to call `ReentrancyVictim.configureTokenToUse()` passing in the address of the deployed attacker contract you noted in step 2.
 4. The attacker needs configured so it knows about the victim. Use e.g. Remix to make a transaction to call `ReentrancyAttackerToken.configureVictimToUse()` passing in the address of the deployed victim contract you noted in step 1.

### Perform Attack
 1. Make a transaction to call `ReentrancyAttackerToken.attack()`. Notice the attack code deposits a value of 10.
 2. Call `ReentrancyVictim.accountBalance` to see the token balance of the attacker contract address. Instead of the expected value of 10, it is 70. The reason why is explained in the comments in `ReentrancyAttackerToken.transferFrom()`.
