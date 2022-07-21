// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";

import "../Bitmap.sol";

interface CheatCodes {
  function prank(address) external;
  function expectRevert(bytes4) external;
  function expectRevert(bytes memory) external;
}

contract ContractTest is IERC721Receiver, DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    Bitmap bitmap;

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns(bytes4) {
        return this.onERC721Received.selector;
    }

    function setUp() public {
        bitmap = new Bitmap();
    }

    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function testMint() public {
        bytes32 bit = stringToBytes32('000000000000000000000000000000000000000000000000000000000000000');
        assertEq(bitmap.balanceOf(address(this)), 0);
        bitmap.mint(bit);
        assertEq(bitmap.balanceOf(address(this)), 1);
    }

    function testTokenURI() public {

        bytes32 bit = stringToBytes32('000000000000000000000000000000000000000000000000000000000000000');
        bitmap.mint(bit);
        string memory uri = bitmap.tokenURI(0);
        assertEq(uri, "/0");
    }


    // function testWithdraw() public {
    //     uint valueToSend = 200;
    //     bytes32 bit = stringToBytes32('000000000000000000000000000000000000000000000000000000000000000');
    //     bitmap.mint{value: valueToSend}(bit);

    //     assertEq(address(bitmap).balance, valueToSend);

    //     uint balanceBefore = address(this).balance;
    //     bitmap.withdraw();
    //     uint balanceAfter = address(this).balance;

    //     assertEq(balanceAfter - balanceBefore, valueToSend);
    // }


 function testWithdrawNotOwner() public {
        cheats.expectRevert(bytes("Ownable: caller is not the owner"));
        cheats.prank(address(1));
        bitmap.withdraw();
    }

}
