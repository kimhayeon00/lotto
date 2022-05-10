// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.7;
contract lotto {
    address public owner;
    address payable[] public participants;
    bool public week_ended;			// 로또 종료 여부
    string public week_status;		// 로또 상황
    uint balance = address(this).balance;
    address payable public winner;

    constructor()  payable {
        owner = msg.sender;
        week_ended = false;
    }

    function play() public payable{
        require(msg.value == 0.1 ether, "You need to have 0.01 ether");
        require(week_ended == false, "Wait for next week");

        participants.push(payable(msg.sender));
    }

    function RandomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants)));
    }

    function raffle() public isOwner {
        uint randomnum = RandomNumber();
        uint idx = randomnum % participants.length;

        winner = participants[idx];
        winner.transfer(payable(address(this)).balance);

        participants = new address payable[](0);
        week_ended = true;
    }

    function getRaffleEtherBalance() view public returns(uint) {
        return address(this).balance;
    }

    function GoingToNextWeekLotto() public {
        week_ended = false;
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    function getParticipantsNumber() view public returns(uint){
        return participants.length;
    }

    function myEtherBalance() view public returns(uint) {
        return (msg.sender).balance/ (10**18);
    }

    function myAddress() view private returns(address){
        return address(msg.sender);
    }


}
