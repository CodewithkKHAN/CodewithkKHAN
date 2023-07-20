// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
contract lottery_trail2{
    address public  manager;
    address payable [] public participants;
    constructor()
    {
        manager=msg.sender; //to set the deployer as manager
    }
    receive() external payable {
        require(msg.value==2 ether); //2 ether is the price for a lottery ticket
        participants.push(payable (msg.sender));//to add the address of player to our participants array
    }
    function getbalance() public view  returns(uint){
        require(msg.sender==manager);//only manager can access the balance
        return address(this).balance;//returns managers accounts balance
    }
    function random() public view returns (uint)
    {
        require(participants.length>=4);// make sure number of participants is minimum 4
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length))); //to generate a random uint
    }
    function selectwinner() public returns(address){
        uint index;
        address payable winner;
        index=random()%participants.length;// to get an integer value less than the number os participants
        winner=participants[index];//getting the address of winner using the index value
        winner.transfer(getbalance());//it will transfer the whole value from manager to winner
        participants=new address payable[](0);//to reset the participant array
        return winner;

    }
}