
const whitelistAddresses = [
    "0x06b14f52c6880bE2a287003C02E6A1924290C33B",
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"
]

const leafNodes = whitelistAddresses.map(addr => keccak256(addr)); 
const merkleTree = new MerkleTree(leafNodes, keccak256, {sortPairs: true});
const rootHash = merkleTree.getRoot().toString('hex'); 


