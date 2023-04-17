pragma solidity ^0.4.0;
contract Crowdfunding{
    struct funder{
        address funderAddr;
        uint money;
    }

    struct needer{
        address neederAddr;
        uint goal;
        uint current;
        uint funderAmount;
        mapping(uint => funder) funderMap;
    }
    
 
    uint neederAmount;
    mapping(uint => needer) neederMap; 
    
   
    function newNeeder(address _neederAddr, uint _goal){
        neederAmount++;
        neederMap[neederAmount] = needer(_neederAddr, _goal, 0, 0);//type mapping can be ignore in constructor
    }

    function contribute(address _funderAddr, uint _neederId) payable{
        needer storage _needer = neederMap[_neederId];
        _needer.current += msg.value;//msg is a global variaty
        _needer.funderAmount++;
        _needer.funderMap[_needer.funderAmount] = funder(_funderAddr, msg.value);
    }
    //judge if the crowdfunding have completed
    function judgeCompleted(uint _neederId){
        needer storage _needer = neederMap[_neederId];
        if(_needer.current >= _needer.goal)
            _needer.neederAddr.transfer(_needer.current);
    }
    //show the status of a needer
    function showNeeder(uint _neederId) view returns(uint, uint, uint){
        needer storage _needer = neederMap[_neederId];
        return(_needer.goal, _needer.current, _needer.funderAmount);
    }
}
