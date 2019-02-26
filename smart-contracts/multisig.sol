pragma solidity ^0.5.0;

contract OneOfTwo {

    address public first;
    address public second;

    event Withdraw(address _from, address _to, uint256 _amount);

    constructor(address _second) public payable {
        first = msg.sender;
        second = _second;
    }

    function withdraw(address payable dst, uint256 _amount) external {
        require(first == msg.sender || second == msg.sender, "Only partisipant");
        require(_amount <= address(this).balance, "Check enough money");
        dst.transfer(_amount);
        emit Withdraw(msg.sender, dst, _amount);
    }

}