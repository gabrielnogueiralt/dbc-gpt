pragma solidity >=0.5.0;

contract ERC20 {

    mapping (address => uint) _balances;
    mapping (address => mapping (address => uint)) _allowed;
    uint public _totalSupply;

    /**
    * Returns the total token supply.
    */
    /// @notice postcondition supply == _totalSupply
    function totalSupply() public view returns (uint256 supply);
    
    /**
    * Transfers `_value` amount of tokens to address `_to`, and MUST fire the `Transfer` event.
    * The function SHOULD `throw` if the message caller's account balance does not have enough tokens to spend.
    * *Note* Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.
    */
    /// @notice postcondition ( ( _balances[msg.sender] ==  __verifier_old_uint (_balances[msg.sender] ) - _value  && msg.sender  != _to ) ||   ( _balances[msg.sender] ==  __verifier_old_uint ( _balances[msg.sender]) && msg.sender  == _to ) && success )   || !success
    /// @notice postcondition ( ( _balances[_to] ==  __verifier_old_uint ( _balances[_to] ) + _value  && msg.sender  != _to ) ||   ( _balances[_to] ==  __verifier_old_uint ( _balances[_to] ) && msg.sender  == _to )  )   || !success
    function transfer(address _to, uint _value) public returns (bool success);

    /**
    * Transfers `_value` amount of tokens from address `_from` to address `_to`, and MUST fire the `Transfer` event.
    * The `transferFrom` method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf.
    * The function SHOULD `throw` unless the `_from` account has deliberately authorized the sender of the message via some mechanism.
    * *Note* Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.
    */
    /// @notice postcondition ( ( _balances[_from] ==  __verifier_old_uint (_balances[_from] ) - _value  &&  _from  != _to ) || ( _balances[_from] ==  __verifier_old_uint (_balances[_from] ) &&  _from == _to ) && success ) || !success 
    /// @notice postcondition ( ( _balances[_to] ==  __verifier_old_uint ( _balances[_to] ) + _value  &&  _from  != _to ) || ( _balances[_to] ==  __verifier_old_uint ( _balances[_to] ) &&  _from  == _to ) && success ) || !success 
    /// @notice postcondition ( _allowed[_from ][msg.sender] ==  __verifier_old_uint (_allowed[_from ][msg.sender] ) - _value && success) || ( _allowed[_from ][msg.sender] ==  __verifier_old_uint (_allowed[_from ][msg.sender]) && !success) ||  _from  == msg.sender
    /// @notice postcondition  _allowed[_from ][msg.sender]  <= __verifier_old_uint (_allowed[_from ][msg.sender] ) ||  _from  == msg.sender
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);

    /**
    * Allows `_spender` to withdraw from your account multiple times, up to the `_value` amount. If this function is called again it overwrites the current allowance with `_value`.
    */
    /// @notice postcondition (_allowed[msg.sender ][ _spender] ==  _value  &&  success) || ( _allowed[msg.sender ][ _spender] ==  __verifier_old_uint ( _allowed[msg.sender ][ _spender] ) && !success )    
    function approve(address _spender, uint _value) public returns (bool success);

    /**
    * Returns the account balance of another account with address `_owner`.
    */
    /// @notice postcondition _balances[_owner] == balance
    function balanceOf(address _owner) public view returns (uint balance);

    /**
    * Returns the amount which `_spender` is still allowed to withdraw from `_owner`.
    */
    /// @notice postcondition _allowed[_owner][_spender] == remaining
    function allowance(address _owner, address _spender) public view returns (uint remaining);
}
