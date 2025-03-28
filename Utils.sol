// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library Utils {
    function encryptData(string memory data) internal pure returns (string memory) {
        return string(abi.encodePacked("Encrypted:", data));
    }
}
