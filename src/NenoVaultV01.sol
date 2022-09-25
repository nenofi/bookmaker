// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract NenoVaultV01 is ERC20, Ownable, ReentrancyGuard{
    address public neToken;
    address public fundManager;

    bool public isPaused;

    mapping(address => uint256) public userShare;

    modifier onlyFundManager{
        require(msg.sender == fundManager, "NENOVAULT: NOT FUND MANAGER");
        _;
    }

    constructor(address _neToken, string memory _name, string memory _symbol) ERC20(_name, _symbol){
        neToken = _neToken;
        isPaused = false;
        fundManager = 0xC739B29c037808e3B9bB3d33d57F1cf0525d7445;
    }

    function balance() public view returns(uint){
        return IERC20(neToken).balanceOf(address(this)) + IERC20(neToken).balanceOf(fundManager);
    }

    function getPricePerFullShare() public view returns (uint256) {
        return totalSupply() == 0 ? 1e18 : (balance()*1e18)/totalSupply();
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
        require(isPaused == false, "NENOVAULT: VAULT IS PAUSED");
        uint256 amount = (balance()*_shares)/totalSupply();
        _burn(msg.sender, _shares);
        IERC20(neToken).transfer(msg.sender, amount);
    }

    function transferToFundManager() public onlyFundManager{
        isPaused = true;
        IERC20(neToken).transfer(fundManager, IERC20(neToken).balanceOf(address(this)));
    }

    function depositForFundManager(uint256 _amount) public onlyFundManager{
        IERC20(neToken).transferFrom(msg.sender, address(this), _amount);
    }

    function emergencyWithdraw(address _to, uint _amount) public onlyOwner{
        IERC20(neToken).transfer(_to, _amount);
    }

    function emergencyWithdrawToken(address _token, address _to, uint _amount) public onlyOwner{
        IERC20(_token).transfer(_to, _amount);
    }

    function setPause(bool _isPaused) public onlyOwner{
        isPaused = _isPaused;
    }  

    function setFundManager(address _fundManager) public onlyOwner{
        fundManager = _fundManager;
    }  
}