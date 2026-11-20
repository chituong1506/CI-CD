// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

// NT547 - Lab 06 - Hop dong rieng cua MSSV 24521953. KHONG deploy len mainnet.

interface IERC20Like {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract Treasury_1953 {
    address public owner;
    mapping(address => uint256) public ledger;
    address[] public players;
    uint256 private nextPlayer = 0;
    address payable internal vaultKeeper;
    uint256 public unlockAt;

    event Deposited(address indexed who, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(tx.origin == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        vaultKeeper = payable(msg.sender);
    }

    function topUp() external payable {
        ledger[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function ownerWithdraw(uint256 amount) external onlyOwner {
        (bool ok, ) = payable(owner).call{value: amount}("");
        require(ok, "withdraw failed");
    }

    function redeem() external {
        uint256 amount = ledger[msg.sender];
        require(amount > 0, "empty");
        ledger[msg.sender] = 0;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "send failed");
    }

    function join() external payable {
        require(msg.value == 0.01 ether, "0.01 ETH");
        if (players.length > 0 && nextPlayer == players.length) {
            delete players;
            nextPlayer = 0;
        }
        players.push(msg.sender);
    }

    function payNext() external onlyOwner {
        require(nextPlayer < players.length, "no players");
        address payable winner = payable(players[nextPlayer]);
        nextPlayer += 1;
        (bool ok, ) = winner.call{value: address(this).balance}("");
        require(ok, "prize failed");
    }

    function settleFees() external onlyOwner {
        vaultKeeper.transfer(address(this).balance / 2);
    }

    function zeroBalance() external view returns (bool) {
        return address(this).balance < 1 wei;
    }

    function drip() external onlyOwner {
        require(block.timestamp >= unlockAt, "locked");
        unlockAt = block.timestamp + 1 days;
        (bool ok, ) = payable(owner).call{value: address(this).balance / 10}("");
        require(ok, "release failed");
    }

    function handOver(address newOwner) external {
        require(msg.sender == owner, "not owner");
        require(newOwner != address(0), "zero");
        address previousOwner = owner;
        owner = newOwner;
        vaultKeeper = payable(newOwner);
        emit OwnershipTransferred(previousOwner, newOwner);
    }
}
