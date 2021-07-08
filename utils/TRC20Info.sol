pragma solidity 0.5.8;

interface ITRC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint256);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
}

contract TRC20Info {
    function symbol(address token) public view returns (string memory) {
        return ITRC20(token).symbol();
    }

    function name(address token) public view returns (string memory) {
        return ITRC20(token).name();
    }

    function totalSupply(address token) public view returns (uint256) {
        return ITRC20(token).totalSupply();
    }

    function balanceOf(address token, address usr) public view returns (uint256) {
        return ITRC20(token).balanceOf(usr);
    }

    function allowance(address token, address owner, address spender) public view returns (uint256) {
        return ITRC20(token).allowance(owner, spender);
    }

    function decimals(address token) public view returns (uint256) {
        return ITRC20(token).decimals();
    }
}
