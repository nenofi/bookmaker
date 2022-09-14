// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NenoVaultV01.sol";
import "../src/test/MockERC20.sol";
import "forge-std/console.sol";

interface CheatCodes {
   // Gets address for a given private key, (privateKey) => (address)
   function addr(uint256) external returns (address);
}

contract NenoVaultV01Test is Test{
    NenoVaultV01 public nenoVaultV01;
    MockERC20 public neIDR;
    uint256 public constant million = 1000000e18;

    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    function setUp() public{
        neIDR = new MockERC20("neRupiah", "neIDR");
        nenoVaultV01 = new NenoVaultV01(address(neIDR), "BookieRupiah", "bNeIDR");
    }

    function testDeposit0() public{
        neIDR.mint(million);
        neIDR.approve(address(nenoVaultV01), million);
        nenoVaultV01.deposit(million);
    }

    // function testDeposit(uint256 _amount) public{
    //     neIDR.mint(_amount);
    //     neIDR.approve(address(nenoVaultV01), _amount);
    //     nenoVaultV01.deposit(_amount);
    // }

}