pragma solidity ^0.5.0;

contract EIP712Contract {

    address buyer;

    uint256 constant chainId = 5777;
    bytes32 constant salt = 0xf2d857f4a3edcb9b78b4d503bfe733db1e3f6cdc2b7971ee739626c97e86a558;

    string private constant EIP712_DOMAIN  = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)";
    string private constant WITHDRAW_TYPE = "Withdraw(address dst)";

    bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked(EIP712_DOMAIN));
    bytes32 private constant WITHDRAW_TYPEHASH = keccak256(abi.encodePacked(WITHDRAW_TYPE));

    constructor() public payable {
        buyer = msg.sender;
    }

    struct Withdraw {
        address dst;
    }

    function getBuyerAddress() public view returns(address) {
        return buyer;
    }

    function getWithdrawHash(address dst) public view returns(bytes32) {
        return hashWithdraw(Withdraw(dst));
    }

    function hashWithdraw(Withdraw memory withdraw) private view returns (bytes32){
        return keccak256(abi.encodePacked(
            "\x19\x01",
            keccak256(abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256("Withdraw dApp"),
                keccak256("2"),
                chainId,
                address(this),
                salt
            )),
            keccak256(abi.encode(
                WITHDRAW_TYPEHASH,
                withdraw.dst
            ))
        ));
    }

    function () external payable {
        //Deposit
    }

    function send(address payable dst, bytes32 r, bytes32 s, uint8 v) public {
        require(buyer == check(dst, r, s, v), "Address should be signed with buyer");
        dst.transfer(this.getAmount());
    }

    function check(address payable dst, bytes32 r, bytes32 s, uint8 v) public view returns(address) {
        return ecrecover(getWithdrawHash(dst), v, r, s);
    }

}