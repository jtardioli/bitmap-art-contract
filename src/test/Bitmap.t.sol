// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;


import "openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../Bitmap.sol";

interface CheatCodes {
    function prank(address) external;
    function expectRevert(bytes4) external;
    function expectRevert(bytes memory) external;
}

contract ContractTest is IERC721Receiver, Test {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    Bitmap bitmap;

    function onERC721Received(address, address, uint256, bytes memory)
        public
        virtual
        override
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

    function setUp() public {
        bitmap = new Bitmap();
    }


    function testMint() public {
        assertEq(bitmap.balanceOf(address(this)), 0);
        bitmap.mint(0x00);
        assertEq(bitmap.balanceOf(address(this)), 1);
    }

    function testTokenURI() public {
        bitmap.mint(0x00);
        string memory uri = bitmap.tokenURI(0);
        assertEq(uri, "/0");
    }

    function testWithdraw() public {
        uint256 amount = 100 ether;
        deal(address(bitmap), amount);

        uint256 balanceBefore = address(this).balance;
        bitmap.withdraw();
        uint256 balanceAfter = address(this).balance;

        assertEq(balanceAfter - balanceBefore, amount);
    }

    function testWithdrawNotOwner() public {
        cheats.expectRevert(bytes("Ownable: caller is not the owner"));
        cheats.prank(address(1));
        bitmap.withdraw();
    }

    fallback() external payable {}
    receive() external payable {}
}
