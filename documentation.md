# POPX BSC BEP20 TOKEN DOCUMENTATION

string public constant <b>name</b> <br />
<i>Token name.</i>

string public constant <b>symbol</b> <br />
<i>Token symbol.</i>

uint8 public constant <b>decimals</b> <br />
<i>Token decimals.</i>

uint256 <b>initialSupply_</b> <br />
<i>Initial quantity distributed (1 billion, in deployer address).</i>

uint256 <b>circulatingSupply_</b> <br />
<i>Sum of tokens contained in all Balances (quantity of transferable tokens).</i>

uint256 <b>stakedSupply_</b> <br />
<i>Sum of tokens contained in all Jars (amount of non-transferable staking tokens).</i>

mapping(address => uint256) <b>balances</b> <br />
<i>Number of tokens available / transferable per user.</i>

mapping(address => uint256 [2]) <b>jars</b> <br />
<i>Number of staking tokens per user (with expiry date specified).</i>

mapping(address => mapping (address => uint256)) <b>allowed</b> <br />
<i>Number of tokens transferable by delegate for specific user.</i>

function <b>initialSupply()</b> public view returns (uint256) <br />
<i>Return initialSupply_ value.</i>

function <b> circulatingSupply() </b> public view returns (uint256) <br />
<i>Return circulatingSupply_ value.</i>
  
function <b>stakedSupply()</b> public view returns (uint256) <br />
<i>Return stakedSupply_ value.</i>
  
function <b>totalSupply()</b> public view returns (uint256) <br />
<i>Return sum of circulatingSupply_ and stakedSupply. <br />
Represents the total number of tokens existing at any given time.</i>

function <b>balanceOf(address tokenOwner)</b> public view returns (uint256) <br />
<i>Returns the amount of tokens in the balance of a specific user account.</i>

function <b>jarBalanceOf(address tokenOwner)</b> public view returns (uint256) <br />
<i>Returns the amount of tokens in the jar of a specific user.</i>

function <b>jarExpirationOf(address tokenOwner)</b> public view returns (uint256) <br />
<i>Returns the expiration date of the jar of a specific user.</i>

function <b>approve(address delegate, uint numTokens)</b> public returns (bool) <br />
<i>Authorize a specific user to transfer a certain amount of tokens on behalf of the current user.</i>

function <b>allowance(address owner, address delegate)</b> public view returns (uint) <br />
<i>Returns the amount of tokens that a user (delegate) can transfer from another user's account.</i>

function <b>getFee(uint256 numTokens)</b> public view returns (uint256) <br />
<i>Given a certain number of tokens, it returns the exact amount of the fee burned in the transfer.</i>

function <b>transfer(address receiver, uint256 numTokens)</b> public returns (bool) <br />
<i>Transfers a certain number of tokens from the current user (balance) to aanother specific user (balance). <br />
If the total quantity of existing tokens exceeds the initial one (contract deployment) the transfer is subject to the burning of a quantity of tokens equal to 1% of the transferred sum.</i>

function <b>transferFrom(address owner, address buyer, uint numTokens)</b> public returns (bool) <br />
<i>Transfers a certain number of tokens from a specific user (balance) whose current user is delegated to another specific user (balance).<br />
If the total quantity of existing tokens exceeds the initial one (contract deployment) the transfer is subject to the burning of a quantity of tokens equal to 1% of the transferred sum. <br />
The fee is burned from the delegating user's balance sheet.</i>
  
function <b>stake(uint256 duration)</b> public returns (bool) <br />
<i>If the current user's jar is empty (therefore no token is staking) it moves the contents of the current user's balance inside it. <br />
The quantity in the jar is blocked from collection until the expiration date chosen by the user.<br />
In exchange, the current user instantly receives the staking interest in his balance (the interest is therefore immediately transferable / spendable). <br />
The interest paid depends on various factors (see whitepaper) and varies in a range between 26% and 405%.</i>

function <b>unstake()</b> public returns (bool) <br />
<i>If the jar's expiration date has passed, it allows the user to redeem the tokens in it by moving them to the balance. <br />
From now on, the tokens are transferable again and it is possible to perform a new stake. </i>
