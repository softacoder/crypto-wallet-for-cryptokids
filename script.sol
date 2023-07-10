// SPDX-License-Identifier: unlicensed

pragma solidity ^0.8.7;

contract CryptoKids{
    address owner;

event LogKidFundingReceived(address addr, uint amount, uint contractBalance);

    constructor(){
        owner = msg.sender;
    } 

    struct Kid {
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

Kid[] public kids;

modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner can add kids");
    _;
}

function addKid(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner {
    kids.push(Kid(
        walletAddress, firstName, lastName, releaseTime, amount, canWithdraw
    ));
}

function balanceOf() public view returns(uint) {
    return address(this).balance;
}

function deposit(address wallettAddress) payable public{
    addToKidsBalance(walletAddress);
}

function addToKidsBalance(address walletAddress) private {
    for(uint; i = 0; i < kids.length; i++) {
        kids[i].amount += msg.value;
        emit LogKidFundingReceived(walletAddress, msg.value, balanceOf());
    }
}

function getIndex(address walletAddress) view private returns(uint) {
    for(uint i=0; i < kids.length; i++){
        if(kids[i].walletAddress) {
            return i;
        }
    }
    return 999; // to use a number 999 is not an ideal solution 
}
function availableToWithdraw(address walletAddress) public returns (bool) {
    uint i = getIndex(walletAddress);
    require(block.timestamp > kids[i].releaseTime, "You cannot withdraw yet");
    if (block.timestamp > kids[i].releaseTime) {
        kids[i].canWithdraw = true;
        return true;
    } else {
        return false;
    }
}

function withdraw(address payable walletAddress) payable public {
    uint i = getIndex(walletAddress);
    require(msg.sender == kids[i].walletAddress, "You must be the kid to withdraw");
    require(kids[1].canWithdraw == true, "You are not able to withdraw at this time");
    kids[i].walletAddress transfer(kids[i]).amount;
}

}

// https://www.youtube.com/watch?v=s9MVkHKV2Vw 