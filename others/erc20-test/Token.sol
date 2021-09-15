pragma solidity ^0.5.8;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

contract Token {
    address public token;
    address public admin;

    constructor() public {
        admin = msg.sender;
    }

    function setToken(address _token) public {
        require(msg.sender == admin, "only owner");
        token = _token;
    }

    function name() public view returns (string memory) {
        return IERC20(token).name();
    }

    function symbol() public view returns (string memory) {
        return IERC20(token).symbol();
    }

    function decimals() public view returns (uint8) {
        return IERC20(token).decimals();
    }

    function totalSupply() public view returns (uint256) {
        return IERC20(token).totalSupply();
    }

    function balanceOf(address account) public view returns (uint256) {
        return IERC20(token).balanceOf(account);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return IERC20(token).allowance(owner, spender);
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        return IERC20(token).transfer(recipient, amount);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        return IERC20(token).approve(spender, value);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        return IERC20(token).transferFrom(sender, recipient, amount);
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        return IERC20(token).increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        return IERC20(token).decreaseAllowance(spender, subtractedValue);
    }

}