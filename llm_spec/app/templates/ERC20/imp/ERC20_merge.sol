// Added by Pedro: Extracted from: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/19c74140523e9af5a8489fe484456ca2adc87484/contracts/token/ERC20/ERC20.sol
// To work with Solidity 0.7, change pragma and add "override" to methods.

pragma solidity >=0.5.7;

import "./IERC20.sol";
// Edited by Pedro to fix path for our repository
import "./math/SafeMath.sol";

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://eips.ethereum.org/EIPS/eip-20
 * Originally based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 *
 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
 * all accounts just by listening to said events. Note that this isn't required by the specification, and other
 * compliant implementations may not do it.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
     * @dev Total number of tokens in existence.
     */
    ///@notice postcondition supply == _totalSupply

    function totalSupply()  public view returns (uint256 supply) {
        return _totalSupply;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the balance of.
     * @return A uint256 representing the amount owned by the passed address.
     */
    ///@notice postcondition _balances[_owner] == balance

    function balanceOf(address _owner)  public view returns (uint256 balance) {
        return _balances[_owner];
    }

    /**
     * @dev Function to check the amount of tokens that an _owner allowed to a _spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the _spender.
     */
    ///@notice postcondition _allowed[_owner][_spender] == remaining

    function allowance(address _owner, address _spender)  public view returns (uint256 remaining) {
        return _allowed[_owner][_spender];
    }

    /**
     * @dev Transfer token _to a specified address.
     * @param _to The address _to transfer _to.
     * @param _value The amount _to be transferred.
     */
    ///@notice postcondition ( ( _balances[msg.sender] ==  __verifier_old_uint (_balances[msg.sender] ) - _value  && msg.sender  != _to ) ||   ( _balances[msg.sender] ==  __verifier_old_uint ( _balances[msg.sender]) && msg.sender  == _to ) && success )   || !success
/// @notice postcondition ( ( _balances[_to] ==  __verifier_old_uint ( _balances[_to] ) + _value  && msg.sender  != _to ) ||   ( _balances[_to] ==  __verifier_old_uint ( _balances[_to] ) && msg.sender  == _to )  )   || !success

    function transfer(address _to, uint256 _value)  public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    ///@notice postcondition (_allowed[msg.sender ][ _spender] ==  _value  &&  success) || ( _allowed[msg.sender ][ _spender] ==  __verifier_old_uint ( _allowed[msg.sender ][ _spender] ) && !success )    

    function approve(address _spender, uint256 _value)  public returns (bool success) {
        _approve(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Transfer tokens _from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param _from address The address which you want to send tokens _from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    ///@notice postcondition ( ( _balances[_from] ==  __verifier_old_uint (_balances[_from] ) - _value  &&  _from  != _to ) || ( _balances[_from] ==  __verifier_old_uint ( _balances[_from] ) &&  _from == _to ) && success ) || !success 
/// @notice postcondition ( ( _balances[_to] ==  __verifier_old_uint ( _balances[_to] ) + _value  &&  _from  != _to ) || ( _balances[_to] ==  __verifier_old_uint ( _balances[_to] ) &&  _from  == _to ) && success ) || !success 
/// @notice postcondition ( _allowed[_from ][msg.sender] ==  __verifier_old_uint (_allowed[_from ][msg.sender] ) - _value && success) || ( _allowed[_from ][msg.sender] ==  __verifier_old_uint (_allowed[_from ][msg.sender]) && !success) ||  _from  == msg.sender
/// @notice postcondition  _allowed[_from ][msg.sender]  <= __verifier_old_uint (_allowed[_from ][msg.sender] ) ||  _from  == msg.sender

    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
        _transfer(_from, _to, _value);
        _approve(_from, msg.sender, _allowed[_from][msg.sender].sub(_value));
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when _allowed[msg.sender][spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Transfer token for a specified addresses.
     * @param from The address to transfer from.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Approve an address to spend another addresses' tokens.
     * @param owner The address that owns the tokens.
     * @param spender The address that will spend the tokens.
     * @param value The number of tokens that can be spent.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
    }
}