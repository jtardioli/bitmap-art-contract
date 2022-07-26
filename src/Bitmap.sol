// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./lib/ERC721A.sol";
import "./lib/BitPackedMap.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

error FailedTransfer();

contract Bitmap is ERC721A, BitPackedMap, Ownable {
    string public baseURI;

    constructor() ERC721A("BitmapArt", "BA") {}

    function mint(bytes32 _bitmapHex) external payable {
        bitmaps[_currentIndex] = _bitmapHex;
        _safeMint(msg.sender, 1);
    }

    function _baseURI()
        internal
        view
        virtual
        override
        returns (string memory)
    {
        return baseURI;
    }

    function updateBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function withdraw() external onlyOwner {
        (bool success,) =
            payable(msg.sender).call{value: address(this).balance}("");
        if (!success) revert FailedTransfer();
    }
}
