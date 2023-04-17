pragma solidity ^0.5.0;
contract Purchase {

address [16] public customers; 

funct ion purchase (uint LessonId) public returns (uint) {

require(lessonId >= 0 && lessonId <= 15); 

customers [lessonId] = msg .sender;

return lessonId;

}

funct ion getCustomers() public view returns (address [16] memory) {
return customers;
}
}