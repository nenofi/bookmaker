pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/EventFactoryV01.sol";

contract EventFactoryV01Test is Test{
    EventFactoryV01 public eventFactory;

    address internal alice = address(0x2);

    function setUp() public{
        eventFactory = new EventFactoryV01(address(this));
    }

    function testSetFeeTo() public{
        eventFactory.setFeeTo(alice);
    }

    function testSetFeeToRevert() public{
        vm.expectRevert('Ownable: caller is not the owner');
        vm.prank(alice);
        eventFactory.setFeeTo(alice);
        vm.stopPrank();
    }
}

