// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IToken {
    function transfer(address _recipient, uint _amount) external returns (bool);
    function totalSupply() external view returns (uint);
    function balanceOf(address _owner) external view returns (uint);
}

contract StandardToken is IToken, Ownable {
    mapping(address => uint) private _balances;
    uint private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(uint totalSupply_, string memory name_, string memory symbol_) {
        _totalSupply = totalSupply_;
        _balances[msg.sender] = totalSupply_;
        _name = name_;
        _symbol = symbol_;
    }

    function totalSupply() external view override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _owner) external view override returns (uint) {
        return _balances[_owner];
    }

    function mint(address _owner, uint _amount) external onlyOwner {
        _totalSupply += _amount;
        _balances[_owner] += _amount;
    }

    function transfer(address _recipient, uint _amount) external override returns (bool) {
        address sender = msg.sender;
        require(sender != address(0), "Invalid sender address");
        require(_recipient != address(0), "Invalid recipient address");
        require(_balances[sender] >= _amount, "Insufficient balance");

        _balances[sender] -= _amount;
        _balances[_recipient] += _amount;

        emit Transfer(sender, _recipient, _amount);
        return true;
    }

    event Transfer(address indexed _from, address indexed _to, uint _value);
}
