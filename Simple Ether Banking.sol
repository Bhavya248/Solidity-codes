// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

// A simple Ether based banking contract with basic functionality linke Deposit,Withdraw,Transfer,etc. 

contract BankSystem {
    address private AdminAdd;
    mapping(address => uint256) internal Balances;
    uint256 internal EtherBal;
    event ETHreceived(string);

    constructor() payable {
        AdminAdd = msg.sender;
    }

    receive() external payable {
        emit ETHreceived("Ethers received Will be reverted");
        payable(msg.sender).transfer(msg.value);
    }

    function GetBal() public view returns (uint256) {
        return Balances[msg.sender];
    }

    function Deposit() public payable returns (bool, uint256) {
        require(address(this).balance == EtherBal + (msg.value));
        {
            Balances[msg.sender] += (msg.value);
            EtherBal += (msg.value);
            return (true, Balances[msg.sender]);
        }
    }

    function Withdraw(uint256 _amt) public returns (bool, uint256) {
        _amt = (_amt) * (10**18);
        require(Balances[msg.sender] >= _amt);
        {
            Balances[msg.sender] -= _amt;
            EtherBal -= _amt;
            bool Status = payable(msg.sender).send(_amt);
            if (Status) {
                return (true, Balances[msg.sender]);
            } else {
                Balances[msg.sender] += _amt;
                EtherBal += _amt;
                return (false, Balances[msg.sender]);
            }
        }
    }

    function transfer(address _add, uint256 _amt)
        public
        returns (bool, uint256)
    {
        require(Balances[msg.sender] >= _amt);
        {
            _amt = (_amt) * (10**18);
            Balances[msg.sender] -= _amt;
            Balances[_add] += _amt;
            return (true, Balances[msg.sender]);
        }
    }
}
