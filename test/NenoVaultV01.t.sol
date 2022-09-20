// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NenoVaultV01.sol";
import "../src/test/MockERC20.sol";

import "forge-std/console.sol";
import "forge-std/Vm.sol";



interface CheatCodes {
   // Gets address for a given private key, (privateKey) => (address)
   function addr(uint256) external returns (address);
}

contract NenoVaultV01Test is Test{
    NenoVaultV01 public nenoVaultV01;
    MockERC20 public neIDR;
    uint256 public constant one_million = 1000000e18;
    uint256 public constant five_million = 5000000e18;

    // address payable[] internal users;
    address internal alice = address(0x1);
    address internal bob = address(0x2);
    address internal admin = address(0x2);



    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    function setUp() public{
        neIDR = new MockERC20("neRupiah", "neIDR");
        nenoVaultV01 = new NenoVaultV01(address(neIDR), "BookieRupiah", "bNeIDR");
    }

    function testVaultLoss() public{
        vm.startPrank(alice);
        neIDR.mint(one_million);
        neIDR.approve(address(nenoVaultV01), one_million);
        uint aliceBefore = neIDR.balanceOf(alice);
        // console.log("ALICE DEPOSITS");
        nenoVaultV01.deposit(one_million);
        console.log(nenoVaultV01.getPricePerFullShare());
        // console.log(nenoVaultV01.balance());
        // console.log(nenoVaultV01.balanceOf(alice));
        // console.log("");
        vm.stopPrank();

        vm.startPrank(bob);
        neIDR.mint(five_million);
        neIDR.approve(address(nenoVaultV01), five_million);
        uint bobBefore = neIDR.balanceOf(bob);
        // console.log("BOB DEPOSITS");
        nenoVaultV01.deposit(five_million);
        console.log(nenoVaultV01.getPricePerFullShare());

        // console.log(nenoVaultV01.balance());
        // console.log(nenoVaultV01.balanceOf(bob));
        // console.log("");
        vm.stopPrank();

        nenoVaultV01.emergencyWithdraw(address(this),500000e18);
        console.log(nenoVaultV01.getPricePerFullShare());

        // console.log(nenoVaultV01.balance());
        // console.log("");

        vm.startPrank(alice);
        // console.log("ALICE WITHDRAWS");
        nenoVaultV01.withdraw(nenoVaultV01.balanceOf(alice));
        // console.log(nenoVaultV01.balanceOf(alice));
        uint aliceAfter = neIDR.balanceOf(alice);
        // console.log(neIDR.balanceOf(alice));
        // console.log("");
        vm.stopPrank();
        assertLe(aliceAfter, aliceBefore);

        vm.startPrank(bob);
        // console.log("BOB WITHDRAWS");
        nenoVaultV01.withdraw(nenoVaultV01.balanceOf(bob));
        // console.log(nenoVaultV01.balanceOf(bob));
        uint bobAfter = neIDR.balanceOf(bob);
        // console.log(neIDR.balanceOf(bob));
        // console.log("");
        vm.stopPrank();
        assertLe(bobAfter, bobBefore);

    }

    function testVaultProfit() public{
        vm.startPrank(alice);
        neIDR.mint(one_million);
        neIDR.approve(address(nenoVaultV01), one_million);
        uint aliceBefore = neIDR.balanceOf(alice);
        // console.log("ALICE DEPOSITS");
        nenoVaultV01.deposit(one_million);
        console.log(nenoVaultV01.getPricePerFullShare());

        // console.log(nenoVaultV01.balance());
        // console.log(nenoVaultV01.balanceOf(alice));
        // console.log("");
        vm.stopPrank();

        vm.startPrank(bob);
        neIDR.mint(five_million);
        neIDR.approve(address(nenoVaultV01), five_million);
        uint bobBefore = neIDR.balanceOf(bob);
        // console.log("BOB DEPOSITS");
        nenoVaultV01.deposit(five_million);
        console.log(nenoVaultV01.getPricePerFullShare());

        // console.log(nenoVaultV01.balance());
        // console.log(nenoVaultV01.balanceOf(bob));
        // console.log("");
        vm.stopPrank();

        neIDR.mint(one_million);
        neIDR.transfer(address(nenoVaultV01), one_million);
        console.log(nenoVaultV01.getPricePerFullShare());

        // console.log(nenoVaultV01.balance());
        console.log("");

        vm.startPrank(alice);
        // console.log("ALICE WITHDRAWS");
        nenoVaultV01.withdraw(nenoVaultV01.balanceOf(alice));
        // console.log(nenoVaultV01.balanceOf(alice));
        uint aliceAfter = neIDR.balanceOf(alice);
        // console.log(neIDR.balanceOf(alice));
        // console.log("");
        vm.stopPrank();
        assertGe(aliceAfter, aliceBefore);

        vm.startPrank(bob);
        // console.log("BOB WITHDRAWS");
        nenoVaultV01.withdraw(nenoVaultV01.balanceOf(bob));
        // console.log(nenoVaultV01.balanceOf(bob));
        uint bobAfter = neIDR.balanceOf(bob);
        // console.log(neIDR.balanceOf(bob));
        // console.log("");
        vm.stopPrank();    
        assertGe(bobAfter, bobBefore);
    }
    
    function testTransferToFundManager() public{
        uint fundManagersBalBefore = neIDR.balanceOf(0xC739B29c037808e3B9bB3d33d57F1cf0525d7445);
        console.log(fundManagersBalBefore);

        vm.startPrank(alice);
        neIDR.mint(one_million);
        neIDR.approve(address(nenoVaultV01), one_million);
        nenoVaultV01.deposit(one_million);
        vm.stopPrank();

        vm.startPrank(0xC739B29c037808e3B9bB3d33d57F1cf0525d7445);
        nenoVaultV01.transferToFundManager();
        uint fundManagersBalAfter = neIDR.balanceOf(0xC739B29c037808e3B9bB3d33d57F1cf0525d7445);
        console.log(fundManagersBalAfter);
        vm.stopPrank();

        assertGe(fundManagersBalAfter, fundManagersBalBefore);
    }

}