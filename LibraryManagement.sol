// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
pragma abicoder v2;


contract BookLibrary {
   address private owner;
    
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    /**
     * @dev Set contract deployer as owner
     */
    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner;
    }
   struct Book {
        uint256 id;
        string name;
    }

    Book[] books;

    mapping(uint256 => address) bookToOwner;
    mapping(uint256 => address[]) public bookToPreviousOwners;

    //make this only avaible for the owner
    function addBook(string memory _name, uint256 quantity) public isOwner {
        require(bytes(_name).length > 0);
        for (uint256 i = 0; i < quantity; i++) {
            books.push(Book(books.length, _name));
        }
    }

    function _isBookAvailable(uint256 _id) internal view returns (bool) {
        if (bookToOwner[_id] == address(0)) {
            return true;
        }
        return false;
    }

    function getbookid(string memory name) public view returns (uint256) {

        uint256 booksResult ;

        for (uint256 i = 0; i < books.length; i++) {
            if (keccak256(bytes(name)) == keccak256(bytes(books[i].name))) {
                    booksResult=books[i].id;
                break;
            }
        }
    
        return booksResult;
        //returns a set of Books {id,name}
    }

    function _hasBorrowedPreviously(uint256 _id) private view returns (bool) {
        for (uint256 i = 0; i < bookToPreviousOwners[_id].length; i++) {
            if (bookToPreviousOwners[_id][i] == msg.sender) {
                return true;
            }
        }

        return false;
    }

    function borrowBook(uint256 _id) public {
        require(_isBookAvailable(_id));
        bookToOwner[_id] = msg.sender;
        if (_hasBorrowedPreviously(_id)) {
            bookToPreviousOwners[_id].push(msg.sender);
        }
    }

    function _isBookOwner(uint256 _id) private view returns (bool) {
        if (bookToOwner[_id] == msg.sender) {
            return true;
        }
        return false;
    }

    function returnBook(uint256 _id) public {
        require(_isBookAvailable(_id) == false);
        require(_isBookOwner(_id));

        delete bookToOwner[_id];
    }
}