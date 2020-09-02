pragma solidity ^0.5.10;

contract SimpleStorageWithCheck
{
    int storedData;

    function set(int x) public
    {
        storedData = x;
    }

    function get() public view returns (int)
    {
        return storedData;
    }

    function setWithCheck(int x) public
    {
        require(x >= 0, "new value must be >= 0");
        storedData = x;
    }
}