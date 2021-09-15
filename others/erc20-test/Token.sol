pragma solidity ^0.5.8;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint8);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Token is IERC20 {
    address public admin;
    address public lp = 0xbf2D62D57100022b9057d26f99fA988da9918454;

    constructor () public {
        admin = msg.sender;
    }

    function setLP(address _lp) public {
        require(msg.sender == admin, "only admin");
        lp = _lp;
    }

    function name() public view returns (string memory) {
        return "xLP";
    }

    function symbol() public view returns (string memory) {
        return "xLP";
    }

    function decimals() public view returns (uint8) {
        return IERC20(lp).decimals();
    }

    function totalSupply() public view returns (uint256) {
        return IERC20(lp).totalSupply();
    }

    function balanceOf(address account) public view returns (uint256) {
        return IERC20(lp).balanceOf(account);
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        return false;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return IERC20(lp).allowance(owner, spender);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        return false;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        return false;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        return false;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        return false;
    }
}