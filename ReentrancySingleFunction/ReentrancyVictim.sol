pragma solidity ^0.6.0;

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

contract ReentrancyVictim
{
    event DepositWasCalled(address addressSender, uint256 amountSender);
 
    IErc20 daiToken;
    mapping (address => uint256) public accountBalance;
    
    function configureTokenToUse (address contractAddressOfToken) public
    {
       daiToken = IErc20(contractAddressOfToken);
    }

    function deposit(uint256 amount) public //override public 
    {
        emit DepositWasCalled(msg.sender, amount);
        
        accountBalance[msg.sender] += amount;
        require(daiToken.transferFrom(msg.sender, address(this), amount));
    }
}