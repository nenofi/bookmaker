// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IEvent{
    function initialize(address betToken, uint8 resultSize, uint256 eventStarts, uint256 eventEnds) external;
}


// contract Event{
//     address public factory;
//     address public admin;
//     address public betToken;

//     mapping(address => mapping(uint8 => uint256)) public userBet; //maps address to result to stake. Represents the shares of the stakes if the address wins
//     mapping(uint8 => uint256) public potPerResult;

//     uint256 public eventStarts;
//     uint256 public eventEnds;

//     constructor(){
//         factory == msg.sender;
//     }

//     function initialize(address _betToken, uint8 _resultSize, uint256 _eventStarts, uint256 _eventEnds) external {
//         admin = tx.origin;
//         betToken = _betToken;
//         for(uint8 i = 0; i < _resultSize; i++){
//             potPerResult[i] = 0;
//         }
//         eventStarts = _eventStarts;
//         eventEnds = _eventEnds;
//     }

// }



contract EventFactoryV01 is Ownable{
    address public feeTo;
    address public feeToSetter;
    // uint256 public eventIndex;

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

    Event[] allEvents;

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