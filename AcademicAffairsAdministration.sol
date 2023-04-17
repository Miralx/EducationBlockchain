// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EAS
{
    address public admin;
    uint public totalStudent;
    struct Student     
    {
         string name;         
         string sex;          
         string DOB;          
         string homeaddress;  
         string StudentID;    
         string StudentClass; 
         uint   tuition;      
         uint   score;       
         bool payed;        
    }mapping(uint => Student) public Students;

    struct LeavingSchoolRequest 
    {
        uint num;             
        string name;        
        string StudentID;     
        string description;   
        string startdate;     
        string enddate;       
        bool   complted;      
        bool   pass;         
    }mapping(uint => LeavingSchoolRequest) public Requests;
    uint public numrequest;  
    constructor () payable 
    {
         admin=msg.sender;
         numrequest=0;
         totalStudent=1;
         Students[0].name="Cai Dingfei";
         Students[0].sex="male";
         Students[0].DOB="20020323";
         Students[0].homeaddress="china";
         Students[0].StudentID="20051607";
         Students[0].StudentClass="20052316";
         Students[0].tuition=11100;
         Students[0].score=100;
         Students[0].payed=false;
         trainingprogram="DO NOT FIND THE TRAINING PLAN";
    }
    modifier onlyadmin()      
     {
         require(msg.sender==admin,"only admin can call the function!");
         _;
     }
    function addStudent(string memory _name,string memory _StudentID,string memory _StudentClass,string memory _sex,string memory _DOB,string memory _homeaddress,uint _tuition,uint _score)public onlyadmin //添加新学生
    {
         Student storage newStudent=Students[totalStudent];
         totalStudent++;
         newStudent.name=_name;
         newStudent.StudentID=_StudentID;
         newStudent.StudentClass=_StudentClass;
         newStudent.sex=_sex;
         newStudent.DOB=_DOB;
         newStudent.homeaddress=_homeaddress;
         newStudent.tuition=_tuition;
         newStudent.score=_score;
         newStudent.payed=false;
    }
     string  public trainingprogram;
     function Uploadthetrainingplan(string memory _trainingprogram)public onlyadmin returns(bool)
     {
       trainingprogram=_trainingprogram;
       return true;
     }

    receive()external payable{

    }
    fallback( )external payable{

    }
    function PayTution(uint _numStudent,address payable _receivingaddress)public payable returns(bool) 
    {
          Student storage thisStudent=Students[_numStudent];
          require(_numStudent < totalStudent,"Student does not exist!"); 
          //require(thisStudent.name == _name && thisStudent.StudentID == _StudentID,"Please check that the student number and name are correct");
          require(thisStudent.payed == false,"The student's tuition has been paid");
          require(msg.sender.balance >= thisStudent.tuition);
          msg.value;
          _receivingaddress.transfer(thisStudent.tuition);
          Students[_numStudent].payed=true;
          return true;
    }
    function balance()public returns(uint)
    {
        return address(this).balance;
    }
    function CreateViewOfLeavingSchhool(uint _num ,string memory _description,string memory _startdate,string memory _enddate)public 
    {
         LeavingSchoolRequest storage newrequest=Requests[numrequest];
         numrequest++;
         newrequest.num=_num;
         newrequest.startdate=_startdate;
         newrequest.enddate=_enddate;
         newrequest.complted=false;
         newrequest.pass=false;
         newrequest.name=Students[_num-1].name;
         newrequest.StudentID=Students[_num-1].StudentID;
         newrequest.description=_description;
    } 
    function AuditRequest(uint _numrequest,bool adopt)public  onlyadmin returns(bool)  
    {
        require(_numrequest < numrequest,"Request does not exist!");               
        LeavingSchoolRequest storage thisrequest=Requests[_numrequest];
        require(thisrequest.complted != true,"This request has been reviewed!");   
        thisrequest.pass=adopt;
        thisrequest.complted=true;
        return true;
    }
    function ManageScore(uint _numStudent,uint score)public onlyadmin returns(bool)
    {
       Student storage thisStudent=Students[_numStudent];
       //string memory StudentID_=_StudentID;
       thisStudent.score = score;
       return true;
    }
}