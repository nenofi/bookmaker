pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/EventFactoryV01.sol";
import "../src/test/MockERC20.sol";

contract EventFactoryV01Test is Test{
    EventFactoryV01 public eventFactory;
    MockERC20 public neIDR;
    uint256 public constant one_million = 1000000e18;
    uint256 public constant five_million = 5000000e18;

    address internal alice = address(0x2);

    function setUp() public{
        neIDR = new MockERC20("neRupiah", "neIDR");
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

    function testCreateEvent() public{
        eventFactory.createEvent("Arsenal-Tottenham",address(neIDR), block.timestamp+1000, 204, 402, 342, 3);
        assertEq(eventFactory.getEvent(0).name, "Arsenal-Tottenham");
        assertEq(eventFactory.allEventsLength(), 1);
    }
}

