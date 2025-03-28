// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Escrow.sol";
import "./Utils.sol";
import "./IPFSStorage.sol";
import "./Oracle.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CHS {
    using Utils for *;

    address public admin;
    Escrow public escrow;
    IPFSStorage public ipfsStorage;
    Oracle public oracle;
    
    mapping(address => string) private encryptedPatientData;

    event PatientRegistered(address patient, string ipfsHash);
    event AccessGranted(address requester, address patient);
    event InsuranceVerified(address patient, uint256 amount);

    constructor(address _escrow, address _ipfsStorage, address _oracle) {
        admin = msg.sender;
        escrow = Escrow(_escrow);
        ipfsStorage = IPFSStorage(_ipfsStorage);
        oracle = Oracle(_oracle);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this");
        _;
    }

    function registerPatient(string memory encryptedData, string memory ipfsHash) public {
        encryptedPatientData[msg.sender] = encryptedData;
        ipfsStorage.storeData(msg.sender, ipfsHash);
        emit PatientRegistered(msg.sender, ipfsHash);
    }

    function grantAccess(address requester) public {
        require(bytes(encryptedPatientData[msg.sender]).length > 0, "No data found");
        emit AccessGranted(requester, msg.sender);
    }

    function verifyInsurance(address patient) public {
        uint256 insuranceAmount = oracle.getInsuranceAmount(patient);
        require(insuranceAmount > 0, "Insurance not found");
        emit InsuranceVerified(patient, insuranceAmount);
    }
}
