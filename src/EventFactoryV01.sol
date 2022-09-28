// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract EventFactoryV01 is Ownable{
    address public feeTo;
    address public feeToSetter;

    struct Event{
        string name;
        address eventToken;
        uint256 eventEnds;
        uint256[] oddsPerOutcome;
        uint8 winner;
        bool claimable;
    }

    struct Bet{
        uint256 eventId;
        uint8 outcome;
    }

    Event[] public allEvents;

    constructor(address _feeToSetter){
        feeToSetter = _feeToSetter;
    }

    function allEventsLength() external view returns(uint){
        return allEvents.length;
    }

    function createEvent(
        string memory _eventName,
        address _eventToken, 
        uint256 _eventEnds, 
        uint256 _odds0,
        uint256 _odds1,
        uint256 _odds2,
        uint8 _resultSize
    ) external {
        uint256[] memory newOdds = new uint256[](_resultSize);
        newOdds[0] = _odds0;
        newOdds[1] = _odds1;
        newOdds[2] = _odds2;
        Event memory newEvent = Event(_eventName, _eventToken, _eventEnds, newOdds, 0, false);
        allEvents.push(newEvent);
    }


    function getEvent(uint256 _index) external view returns (Event memory){
        return allEvents[_index];
    }

    function setFeeTo(address _feeTo) onlyOwner external{
        feeTo = _feeTo;
    }
}