// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract main {
	constructor() { owner = payable(msg.sender); }
	address payable owner;

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
	struct Player
	{
		string	userName;
	}

	mapping(address => Player) players;


	struct Tournament
	{
		string	name;
		uint256	price;
		uint256 startTime;
		address[] regPlayers;
	}

	Tournament[] public tournaments; 
	
	function createTounament(string memory _tournamentName,uint256 _price,uint256 _startTime, address[] memory _regPlayers) public payable onlyOwner
	{
		_price = msg.value;
		tournaments.push(Tournament(_tournamentName,_price,_startTime,_regPlayers));
	}

	function createPlayer(string memory _userName) public validPlayer
	{
		address _playerAddress = msg.sender;
		Player memory newPlayer = Player(_userName);
		players[_playerAddress] = newPlayer;
	}

	function registerForTournament(uint _index) public
	{
		tournaments[_index].regPlayers.push(msg.sender);
	}

}
