// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract main 
{
	constructor() { owner = payable(msg.sender); }
	address payable owner;

	//Modifiers

	modifier onlyOwner 
	{
		require(msg.sender == owner, "You are not the owner");
		_;
	}
	modifier validPlayer
	{
		require(bytes(players[msg.sender].userName).length != 0, "This address is not linked to any player");
		_;
	}

	//Structures 

	struct Player
	{
		string	userName;
	}
	
	struct Tournament
	{
		string	name;
		uint256	price;
		uint256 startTime;
		address[] regPlayers;
		uint8 regFee;
		uint256 creationTime;
		uint8 maxPlayers;
		address winner;
	}

	//Mappings
	mapping(address => Player) players;
	//Arrays

	Tournament[] public tournaments;
	string[] public activeUserNames;

	//Check the players registered for a specific tournament
	
	function getRegPlayers(uint8 _index) public view returns (address[] memory)
	{
		require(_index < tournaments.length, "Tournament index out of bounds");
		return tournaments[_index].regPlayers;
	}

	//Create a new tournament , making sure that the tournament doest already exist
	function createTounament
	(
		string memory _tournamentName,uint256 _price,uint256 _startTime, 
		address[] memory _regPlayers, uint8 _regFee,
		uint8 _maxPlayers
	) 
		public payable onlyOwner
	{
		_price = msg.value;

		tournaments.push(Tournament(_tournamentName,_price,_startTime,_regPlayers,
		_regFee,block.timestamp,_maxPlayers,address(0)));
	}

	//Create a new player making sure it doesnt already exist
	function createPlayer(string memory _userName) public 
	{
		address _playerAddress = msg.sender;
    		require(bytes(players[_playerAddress].userName).length == 0, "Player already exists with this address");
  		for (uint8 i = 0; i < activeUserNames.length; i++) 
		{
			string memory existingName = activeUserNames[i];
			if (keccak256(abi.encodePacked(existingName)) == keccak256(abi.encodePacked(_userName))) 
				{
					revert("Name already taken");
				}
		}
		require(bytes(_userName).length > 0,"Please enter a valid username");
		Player memory newPlayer = Player(_userName);
		players[_playerAddress] = newPlayer;
		activeUserNames.push(_userName);
	}

	//Check if the player doesnt already exist
	function registerForTournament(uint _index) public payable validPlayer
	{
		
		require(block.timestamp >= tournaments[_index].creationTime,"Tournament not opened yet");
		for (uint8 i = 0; i < tournaments[_index].regPlayers.length; i++) 
		{
			if (tournaments[_index].regPlayers[i] == msg.sender) 
				{
					revert("You have already registered for this event");
				}
		}
		require(msg.value >= tournaments[_index].regFee, "Please send the right registration fee");
		require(tournaments[_index].regPlayers.length < tournaments[_index].maxPlayers,"This tournament is complete");
		tournaments[_index].regPlayers.push(msg.sender);

	}

	function checkResult(string memory  _name) public returns(bool)
	{

		Tournament memory toCheck;
		for(uint i = 0; i < tournaments.length; i++)
		{
			if (keccak256(abi.encodePacked(tournaments[i].name)) == keccak256(abi.encodePacked(_name)))	
				{
					if (tournaments[i].winner == msg.sender)
						{
							return(true);
						}
					else
						{
							return(false);
						}


				}
		}
	
	}

	function setTournamentWinner(string memory _tournament, address _winner) public onlyOwner
	{
		for(uint i ; i < tournaments.length; i++)
		{
			if (keccak256(abi.encodePacked(tournaments[i].name)) == keccak256(abi.encodePacked(_tournament)))	
				{
					tournaments[i].winner == _winner;
				}
		}
	}




}
