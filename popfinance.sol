pragma solidity ^0.4.22;

contract PopFinance {

    string public constant name = "Pop Finance";
    string public constant symbol = "POPX";
    uint8 public constant decimals = 18;
    
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
	event Stake(address indexed tokenOwner, uint staked, uint expiration, uint interest);
	event Unstake(address indexed tokenOwner, uint staked);
	
	uint256 initialSupply_;
	uint256 circulatingSupply_;
	uint256 stakedSupply_;
	
	mapping(address => uint256) balances;
	mapping(address => uint256 [2]) jars;
	mapping(address => mapping (address => uint256)) allowed;
		
    using SafeMath for uint256;

	constructor(uint256 total) public {
		
		balances[msg.sender] = total;
		circulatingSupply_ = total;
		initialSupply_ = total;
		
    }
	
    function initialSupply() public view returns (uint256) {

		return initialSupply_;

    }

    function circulatingSupply() public view returns (uint256) {

		return circulatingSupply_;

    }

    function stakedSupply() public view returns (uint256) {

		return stakedSupply_;

    }
    
    function totalSupply() public view returns (uint256) {
        
	    return (circulatingSupply_ + stakedSupply_);
	    
    }

    function balanceOf(address tokenOwner) public view returns (uint256) {

        return balances[tokenOwner];

    }
    
    function jarBalanceOf(address tokenOwner) public view returns (uint256) {

        return jars[tokenOwner][0];

    }
	
	function jarExpirationOf(address tokenOwner) public view returns (uint256) {

        return jars[tokenOwner][1];

    }
    
    function approve(address delegate, uint numTokens) public returns (bool) {
        
        allowed[msg.sender][delegate] = numTokens;
        
        emit Approval(msg.sender, delegate, numTokens);
        
        return true;
        
    }
    
    function allowance(address owner, address delegate) public view returns (uint) {
        
        return allowed[owner][delegate];
        
    }
    
    function getFee(uint256 numTokens) public view returns (uint256) {
		        								
		uint256 fee;

		if(totalSupply() > initialSupply_) { fee = (numTokens/100); }
												
		return fee;
        
    }
    
    function transfer(address receiver, uint256 numTokens) public returns (bool) {
		
		uint256 fee = getFee(numTokens);
		
        require((numTokens+fee) <= balances[msg.sender]);
		
        balances[msg.sender] = balances[msg.sender].sub(numTokens+fee);
        balances[receiver] = balances[receiver].add(numTokens);
		circulatingSupply_ = circulatingSupply_ - fee;
		
		emit Transfer(msg.sender, receiver, numTokens);

        return true;

    }
    
    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        
        require(numTokens <= allowed[owner][msg.sender]);
		
		uint256 fee = getFee(numTokens);
		
        require((numTokens+fee) <= balances[owner]);
		
        balances[owner] = balances[owner].sub(numTokens+fee);
        balances[buyer] = balances[buyer].add(numTokens);
		circulatingSupply_ = circulatingSupply_ - fee;
		
		allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
		
		emit Transfer(owner, buyer, numTokens);

        return true;
        
    }
	
	function stake(uint256 duration) public returns (bool) {
	
		require((duration == 15) || (duration == 30) || (duration == 60) || (duration == 90));
		require(balances[msg.sender] > 100);
		require(jars[msg.sender][0] == 0);
				
		uint256 expDate = block.timestamp + (86400*duration);
		uint256 ts = totalSupply();
		uint256 percentage;
		uint256 interest;
				
		if(ts <= 1250000000 *(10**18)) { percentage = 4; }
		if((ts > 1250000000 *(10**18)) && (ts <= 1500000000 *(10**18))) { percentage = 3; }
		if((ts > 1500000000 *(10**18)) && (ts <= 1750000000 *(10**18))) { percentage = 2; }
		if(ts > 1750000000 *(10**18)) { percentage = 1; }
		
		if(duration == 30) { percentage = (percentage + 1); }
		if(duration == 60) { percentage = (percentage + 2); }
		if(duration == 90) { percentage = (percentage + 3); }
		
		percentage = (((100+percentage)**(duration/15))/(100**((duration/15)-1)))-100;
		
		interest = ((balances[msg.sender]/100)*percentage); 
		
		jars[msg.sender][0] = balances[msg.sender];
		jars[msg.sender][1] = expDate;
		balances[msg.sender] = 0;
		
		circulatingSupply_ = circulatingSupply_.sub(jars[msg.sender][0]);
		stakedSupply_ = stakedSupply_.add(jars[msg.sender][0]);
		
		balances[msg.sender] = interest;
		circulatingSupply_ = circulatingSupply_.add(interest);
		
		emit Stake(msg.sender, jars[msg.sender][0], jars[msg.sender][1], balances[msg.sender]);
				
		return true;
		
    }
	
	function unstake() public returns (bool) {
			
		require(jars[msg.sender][0] > 0);
		require(jars[msg.sender][1] < block.timestamp);
		
		uint256 sq = jars[msg.sender][0];
		
		balances[msg.sender] = balances[msg.sender].add(sq);
		
		jars[msg.sender][0] = 0;
		jars[msg.sender][1] = 0;

		stakedSupply_ = stakedSupply_.sub(sq);
		circulatingSupply_ = circulatingSupply_.add(sq);
		
		emit Unstake(msg.sender, sq);
		
		return true;
				
    }

}

library SafeMath {

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }

}
