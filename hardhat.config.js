require("@nomiclabs/hardhat-waffle");
require('dotenv').config();  
require("@nomiclabs/hardhat-etherscan");


// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
    solidity: "0.8.4",
    networks: {
        ropsten: {
          url: process.env.RINKEBY_URL,
          accounts: [`0x${process.env.WALLET_PRIVATE_KEY}`]
        }
      }, 
    etherscan: {
        apiKey: process.env.API_KEY
      }
    
};
