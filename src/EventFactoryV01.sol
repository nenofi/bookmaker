// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventFactoryV01 is Ownable{
    address public feeTo;
    address public feeToSetter;

    mapping(address => address) public getEvent;
    address[] public allEvents;

    constructor(address _feeToSetter) public{
        feeToSetter = _feeToSetter;
    }

    function allEventsLength() external view returns(uint){
        return allEvents.length;
    }

    function createEvent(address _eventToken, uint8 _resultsArraySize, uint256 eventStarts, uint256 eventEnds){
        return;
    }

    function setFeeTo(address _feeTo) onlyOwner external{
        feeTo = _feeTo;
    }
}