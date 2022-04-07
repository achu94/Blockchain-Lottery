// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Lottery {
    address public manager;
    address[] public players;
    address payable private winner;

    constructor(){
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > .01 ether, "No money bro!");
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players)));
    }

    function pickWinner() public restricted{
        uint index = random() % players.length;
        payable(players[index]).transfer(address(this).balance);

        resetLottery();
    }

    function resetLottery() private {
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager, "Restricted");
        _;
    }

    function getPlayers() public view returns (address[] memory){
        return players;
    }
}