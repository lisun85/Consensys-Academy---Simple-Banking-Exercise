/*
    This exercise has been updated to use Solidity version 0.6.12
    Breaking changes from 0.5 to 0.6 can be found here: 
    https://solidity.readthedocs.io/en/v0.6.12/060-breaking-changes.html
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;


contract SimpleBank {

    //
    // State variables
    //
    
    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping (address => uint) internal balances;
    
    /* Fill in the keyword. We want to create a getter function and allow contracts to be able to see if a user is enrolled.  */
    mapping (address => bool) public enrolled;

    /* Let's make sure everyone knows who owns the bank. Use the appropriate keyword for this*/
    address public owner;
    
    //
    // Events - publicize actions to external listeners
    //
    
    /* Add an argument for this event, an accountAddress */
    event LogEnrolled(address accountAddress);

    /* Add 2 arguments for this event, an accountAddress and an amount */
    event LogDepositMade(address accountAddress, uint amount);

    /* Create an event called LogWithdrawal */
    /* Add 3 arguments for this event, an accountAddress, withdrawAmount and a newBalance */
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);


    //
    // Functions
    //

    /* Use the appropriate global variable to get the sender of the transaction */
    constructor() payable public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
    }



    /// @notice Get balance CHECK
    /// @return The balance of the user CHECK
    // A SPECIAL KEYWORD prevents function from editing state variables; CHECK
    // allows function to run locally/off blockchain CHECK
    function getBalance() public view returns(uint) {
        /* Get the balance of the sender of this transaction */
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank CHECK
    /// @return The users enrolled status CHECK
    // Emit the appropriate event CHECK
    function enroll() public returns(bool) {
        enrolled[msg.sender] = true;    
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank CHECK
    /// @return The balance of the user after the deposit is made CHECK
    // Add the appropriate keyword so that this function can receive ether CHECK
    // Use the appropriate global variables to get the transaction sender and value CHECK
    // Emit the appropriate event CHECK
    // Users should be enrolled before they can make deposits CHECK
    function deposit() public payable returns(uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
          require(enrolled[msg.sender] == true, "user must enrolled");
          
          balances[msg.sender] += msg.value;
          emit LogDepositMade(msg.sender, msg.value);
          return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank CHECK
    /// @dev This does not return any excess ether sent to it 
    /// @param withdrawAmount amount you want to withdraw CHECK
    /// @return The balance remaining for the user CHECK
    // Emit the appropriate event  CHECK
    function withdraw(uint withdrawAmount) public payable returns (uint) {
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw. 
           return the user's balance.*/
        require(balances[msg.sender] >= withdrawAmount);
        
        balances[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return balances[msg.sender];
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data 
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract ADDED EXTERNAL AND PAYABLE TO FALLBACK FUNCTION
    function () external payable {
        revert();
    }
}
