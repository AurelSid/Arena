const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Arena", (m) => {
  const AR = m.contract("AR",[10000]);
	return {AR};
});
