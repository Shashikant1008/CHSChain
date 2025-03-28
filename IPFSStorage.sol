// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract IPFSStorage {
    mapping(address => string) public patientRecords;

    function storeData(address patient, string memory ipfsHash) public {
        patientRecords[patient] = ipfsHash;
    }

    function getData(address patient) public view returns (string memory) {
        return patientRecords[patient];
    }
}
