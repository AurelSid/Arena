## ARENA - A solidity smart contract for gaming tounaments. 
This a smart contract coded in soldity to allow wallets(users) to register for owner created tournaments.

Language: Solidity <img src= "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Solidity_logo.svg/1319px-Solidity_logo.svg.png" width="25" height="35">\
Framework: Hardhat <img src = "https://seeklogo.com/images/H/hardhat-logo-888739EBB4-seeklogo.com.png" width="25" height="25">\
Testing: Chai <img src = "https://ethereum-waffle.readthedocs.io/en/latest/_static/waffle-logo-square.svg" width="30" height="30">

### ATTENTION!This contract is a working concept but not audited and mainNet deployed ! Use it as reference or inspiration but do NOT use it or deploy it on mainNet.

Each tournament consists of a structures with basics needed members like the winning price , time , max players etc...feel free to cusotmise your tounaments.\
This contract is an ERC20 , creating a custom token for the project , allowing felixibility when working with balances and transfers before withdrawal.\
All tests are running , making sur all requirement pass for a robust contract.

Main functions

- Create a tournament
- Create players (one per address)
- Register for a tournament
- Check tournaments winner (price transfer is automatic)

<img src = "https://github.com/AurelSid/Arena/assets/48348299/c79580e9-8377-40e5-9062-68a17083dbbe">

npx hardhat help\
npx hardhat test\
npx hardhat node



