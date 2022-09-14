// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


// import "../test/MockERC20.sol";
import "forge-std/console.sol";


contract NenoVaultV01 is ERC20, Ownable, ReentrancyGuard{
    address public neToken;

    bool public isPaused;
    uint256 public vaultBalance;
    uint256 public exchangeRate;

    mapping(address => uint256) public userShare;

    constructor(address _neToken, string memory _name, string memory _symbol) ERC20(_name, _symbol){
        neToken = _neToken;
        isPaused = false;
    }

    function balance() public view returns(uint){
        return IERC20(neToken).balanceOf(address(this));
    }

    function deposit(uint _amount) public nonReentrant {
        uint256 _pool = balance();
        IERC20(neToken).transferFrom(msg.sender, address(this), _amount);
        uint256 _after = balance();
        _amount = _after - _pool; // Additional check for deflationary tokens
        uint256 shares = 0;
        if (totalSupply() == 0) {
            shares = _amount;
        } else {
            shares = (_amount*totalSupply())/(_pool);
        }
        _mint(msg.sender, shares);
    }

    function withdraw(uint256 _shares) public {
        uint256 amount = balance()*_shares/totalSupply();
        _burn(msg.sender, _shares);
        IERC20(neToken).transfer(msg.sender, amount);
    }

    function emergencyWithdraw(address _to, uint _amount) public {
        IERC20(neToken).transfer(_to, _amount);
    }


}