// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IEvent{
    function initialize(address betToken, uint8 resultSize, uint256 eventStarts, uint256 eventEnds) external;
}


contract Event{
    address public factory;
    address public admin;
    address public betToken;

    mapping(address => mapping(uint8 => uint256)) public userBet; //maps address to result to stake. Represents the shares of the stakes if the address wins
    mapping(uint8 => uint256) public potPerResult;

    uint256 public eventStarts;
    uint256 public eventEnds;

    constructor(){
        factory == msg.sender;
    }

    function initialize(address _betToken, uint8 _resultSize, uint256 _eventStarts, uint256 _eventEnds) external {
        admin = tx.origin;
        betToken = _betToken;
        for(uint8 i = 0; i < _resultSize; i++){
            potPerResult[i] = 0;
        }
        eventStarts = _eventStarts;
        eventEnds = _eventEnds;
    }

}



contract EventFactoryV01 is Ownable{
    address public feeTo;
    address public feeToSetter;

    // mapping(uint256 => address) public getEvent;
    address[] public allEvents;

    constructor(address _feeToSetter){
        feeToSetter = _feeToSetter;
    }

    function allEventsLength() external view returns(uint){
        return allEvents.length;
    }

    function createEvent(address _betToken, uint8 _resultSize, uint256 _eventStarts, uint256 _eventEnds) external returns(address ev){
        bytes memory bytecode = type(Event).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(_betToken, _resultSize, _eventStarts, _eventEnds));
        assembly {
            ev := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        IEvent(ev).initialize(_betToken, _resultSize, _eventStarts, _eventEnds);
        allEvents.push(ev);
    }

    function setFeeTo(address _feeTo) onlyOwner external{
        feeTo = _feeTo;
    }
}