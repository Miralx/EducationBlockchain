// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;
contract User {
    
    struct Record {
        string name;
        uint age;
        string education; 
        string skills; 
        uint experience; 
        uint status; 
    } 
    
    mapping(address=>Record) records;

    
    address public owner;
    enum Role { User, Admin }   
    mapping (address => Role) public roles;

    constructor(){
        owner = msg.sender;
        roles[owner] = Role.User;
    }

    
    modifier onlyUser() {
        require(
            roles[msg.sender] == Role.User,
            "Only user can call this."
        );
        _;
    }

    
    modifier onlyAdmin() {
        require(
            roles[msg.sender] == Role.Admin,
            "Only admin can call this."
        );
        _;
    }

    
    function addRecord(string memory _name, uint _age, string memory _education, string memory _skills, uint _experience) onlyUser public {
        require(roles[msg.sender] == Role.User, "Only owner can add records");
        
        records[msg.sender] = Record(_name, _age, _education, _skills, _experience, 0);
    }


    
    function updateRecord(string memory _name, uint _age, string memory _education, string memory _skills, uint _experience) onlyUser public {
        require(roles[msg.sender] == Role.User, "Only owner can update records");
        records[msg.sender].name = _name;
        records[msg.sender].age = _age;
        records[msg.sender].education = _education;
        records[msg.sender].skills = _skills;
        records[msg.sender].experience = _experience;
    }

    
    function deleteRecord() onlyUser public {
        require(roles[msg.sender] == Role.User, "Only owner can delete records");
        delete records[msg.sender];
    }

    
    function getRecord() public view returns (string memory, uint, string memory, string memory, uint, uint) {
        return (        
            records[msg.sender].name,
            records[msg.sender].age,
            records[msg.sender].education,
            records[msg.sender].skills,
            records[msg.sender].experience,
            records[msg.sender].status
        ); 
    }

   
    function getPassedRecords(address[] memory userAddress) onlyAdmin public view returns (Record[] memory) {
        Record[] memory result;
        for(uint i = 0; i < userAddress.length; i++){
            address user = userAddress[i];
            if(records[user].status == 1){
                result[i] = records[user];
            } 
        }

        return result;
    }

    
    function getPendingRecords(address[] memory userAddress) onlyAdmin public view returns (Record[] memory) {
        Record[] memory result;
        for(uint i = 0; i < userAddress.length; i++){
            address user = userAddress[i];
            if(records[user].status == 0){
                result[i] = records[user];
            } 
        }

        return result;
    }

    
    function approvalRecord(uint status, address userAddress) onlyAdmin public {
        roles[msg.sender] = Role.Admin;
        require(roles[msg.sender] == Role.Admin, "Only admin can approval records");
        records[userAddress].status = status;
    }

    
    function compare(string memory a, string memory b) internal pure returns (bool) {
        if (bytes(a).length != bytes(b).length) {
            return false;
        }
        for (uint i = 0; i < bytes(a).length; i ++) {
            if(bytes(a)[i] != bytes(b)[i]) {
                return false;
            }
        }
        return true;
    }

    
    function groupBySkill(address[] memory userAddress, string memory skill) onlyAdmin public returns (Record[] memory){
        roles[msg.sender] = Role.Admin;
        require(roles[msg.sender] == Role.Admin, "Only admin can group records");
        Record[] memory result;
         for(uint i = 0; i < userAddress.length; i++){
            address user = userAddress[i];
            if(compare(records[user].skills, skill) == true){
                result[i] = records[user];
            } 
        }
        return result;
    }

    
    function groupBySkill(address[] memory userAddress, uint experience) onlyAdmin public returns (Record[] memory){
        roles[msg.sender] = Role.Admin;
        require(roles[msg.sender] == Role.Admin, "Only admin can group records");
        Record[] memory result;
         for(uint i = 0; i < userAddress.length; i++){
            address user = userAddress[i];
            if(records[user].experience >= experience){
                result[i] = records[user];
            } 
        }
        return result;
    }
}




