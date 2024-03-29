// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract AR is ERC20
{	
	address owner;
	constructor(uint256 initialSupply) ERC20("Arena", "AR") 
	{
		_mint(msg.sender, initialSupply);

		owner = payable(msg.sender);

	}



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
		uint256 balance;
	}
	
	struct Tournament
	{
		string	name;
		uint256	price;
		uint256 startTime;
		uint256 endTime;
		address[] regPlayers;
		uint8 regFee;
		uint256 creationTime;
		uint8 maxPlayers;
		address winner;
	}

	//Mappings
	mapping(address => Player) public players;
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
	function createTournament
	(
		string memory _tournamentName,uint256 _price,uint256 _startTime, uint256 _endTime,
		address[] memory _regPlayers, uint8 _regFee,
		uint8 _maxPlayers
	) 
		public payable onlyOwner
	{
		_price = msg.value;

		tournaments.push(Tournament(_tournamentName,_price,_startTime,_endTime,_regPlayers,
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
		Player memory newPlayer = Player(_userName,0);
		players[_playerAddress] = newPlayer;
		activeUserNames.push(_userName);
	}

	//Register for a tournament
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
	
	//Check if sender won the tournament
	function checkResult(string memory  _name) public view returns(bool _result)
	{
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

	//Set the tournament winner (API in final version)
	function setTournamentWinner(string memory _tournament, address _winner) public  onlyOwner  {
	    bool tournamentExists = false;
	    for (uint i = 0; i < tournaments.length; i++) 
	    {
		if (keccak256(abi.encodePacked(tournaments[i].name)) == keccak256(abi.encodePacked(_tournament))) {
			require(tournaments[i].endTime < block.timestamp,"This tournament in not over");
			tournaments[i].winner = _winner;
			transfer(_winner,tournaments[i].price);
			players[_winner].balance += tournaments[i].price;//ERC20 implementation for final verison
			tournamentExists = true;
			break; 
		}
	    }
	    if (!tournamentExists) {
		revert("Non-valid tournament");
	    }
	}


}
