// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./lib/ERC721A.sol";
import "./lib/BitPackedMap.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

error FailedTransfer();

contract Bitmap is ERC721A, BitPackedMap, Ownable{

  constructor() ERC721A("Poop", "Poop") {}

  function mint(bytes32 _bitmapHex) external payable {
       bitmaps[_currentIndex] = _bitmapHex;
        _safeMint(msg.sender, 1);
  }

  function _baseURI() internal view virtual override returns (string memory) {
        return "/"; //todo make not empty
  }


  // incase somebody send us free money
  function withdraw() external onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    if (!success) revert FailedTransfer();
  }

}