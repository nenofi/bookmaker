// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "../src/BookmakerV02.sol";
// import "../src/test/MockERC20.sol";

// import "forge-std/console.sol";
// // import "forge-std/Vm.sol";

// contract BookmakerV02Test is Test {
//     BookmakerV02 public bookmakerV02;
//     MockERC20 public neIDR;
//     uint256 public constant one_million = 1000000e18;
//     uint256 public constant five_million = 5000000e18;

//     // address payable[] internal users;
//     address internal alice = address(0x1);
//     address internal bob = address(0x2);
//     address internal admin = address(0x2);

//     function setUp() public {
//         neIDR = new MockERC20("neRupiah", "neIDR");
//         uint256 currentTime = block.timestamp;
//         bookmakerV02 = new BookmakerV02(address(neIDR), currentTime+1000);
//     }

//     function testBet() public{
//         vm.startPrank(alice);
//         neIDR.mint(one_million);
//         neIDR.approve(address(bookmakerV02), one_million);

//         bookmakerV02.bet(address(neIDR), one_million, 0);

//     }

// }
