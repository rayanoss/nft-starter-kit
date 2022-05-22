//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; 
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract Nerds is ERC721, Ownable, PaymentSplitter{
    using Counters for Counters.Counter; 
    
    // METADATA
    string public baseTokenURI; 
    string public hiddenMetaDataURI;
    string public teamRevealURI;
    string public uriSuffix = '.json';

    // NFT INFORMATIONS
    uint private priceNFT = 3 ether; 
    uint8 private maxSupply = 100; 
    uint8 private maxPerWallet = 3; 
    Counters.Counter private tokenIdCounter;

    // SALE INFORMATIONS
    bool public reveal = false;
    struct MintState {
        bool publicMint;
        bool whitelistMint;
    }
    MintState mintState = MintState(false, false);

    // WHITELIST
    bytes32 public merkleRoot; 
    mapping (address => bool) public claimed; 

    address[] public staff = [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0x06b14f52c6880bE2a287003C02E6A1924290C33B];

    constructor(string memory _hiddenMetaDataURI, bytes32 _merkleRoot, address[] memory _payees, uint256[] memory _shares) ERC721("NerdsNFT", "NERDS") PaymentSplitter(_payees, _shares) payable{
        tokenIdCounter.increment();
        setHiddenMetaDataURI(_hiddenMetaDataURI);
        setMerkleRoot(_merkleRoot); 
       // GIVE NFT TO TEAM MEMBERS _safeMint(staff[2], tokenIdCounter.current()); 
       // GIVE NFT TO TEAM MEMBERS _safeMint(staff[2], tokenIdCounter.current()); 
       // GIVE NFT TO TEAM MEMBERS _safeMint(staff[2], tokenIdCounter.current()); 
       // GIVE NFT TO TEAM MEMBERS _safeMint(staff[2], tokenIdCounter.current()); 
    }

    function mintNerds(uint8 _quantity, bytes32[] calldata _merkleProof) public payable {
        if(mintState.publicMint){
            require(mintState.publicMint, "Minting has not yet been activated"); 
            require (tokenIdCounter.current() <= maxSupply, "Max supply exceed"); 
            require(balanceOf(msg.sender) < 3, "Limit per wallet exceed"); 
            require(msg.value >= priceNFT, "Wrong mint value"); 

            for (uint8 i; i < _quantity; i++){
                _safeMint(msg.sender, tokenIdCounter.current()); 
                tokenIdCounter.increment(); 
            }
        }else if(mintState.whitelistMint){
            require(claimed[msg.sender] == false, "You have already claimed your NerdsNFT");
            claimed[msg.sender] = true; 
            require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You're not whitelisted");
            require (tokenIdCounter.current() <= maxSupply, "Max supply exceed");
            require(balanceOf(msg.sender) < 3, "Limit per wallet exceed"); 
            require(msg.value >= priceNFT, "Wrong mint value"); 

             for (uint8 i; i < _quantity; i++){
                _safeMint(msg.sender, tokenIdCounter.current()); 
                tokenIdCounter.increment(); 
            }
        }
        if(mintState.publicMint == false && mintState.whitelistMint == false){
            revert("Sale has not yet been activated");
        }
        
    }

    function setMerkleRoot(bytes32 _merkleProof) public onlyOwner {
        merkleRoot = _merkleProof;
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        priceNFT = _newPrice;
    }

    function getPrice() public view returns(uint){
        return priceNFT; 
    }

    function getSaleState() public view returns(MintState memory){
        return mintState; 
    }

    function _baseURI() internal view override returns (string memory){
        return baseTokenURI; 
    }

    function getTeamRevealURI() internal view returns (string memory){
        return teamRevealURI; 
    }

    function setTeamRevealURI(string memory _teamRevealURI) public onlyOwner{
        teamRevealURI = _teamRevealURI;
    }

    function setBaseURI(string memory _MetadataURI) public onlyOwner{
        baseTokenURI = _MetadataURI; 
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (!reveal){
            for (uint8 i=0; i <= staff.length - 1; i++){
                if(ownerOf(_tokenId) == staff[i]){
                    string memory onlyTeamRevealURI = getTeamRevealURI();
                    return bytes(onlyTeamRevealURI).length > 0
                        ? string(abi.encodePacked(onlyTeamRevealURI, Strings.toString(_tokenId), uriSuffix))
                        : '';
                }
            }
            return hiddenMetaDataURI;
        }

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
            : '';
  }

    function setRevealed(bool _state) public onlyOwner {
        reveal = _state;
    }

    function setHiddenMetaDataURI(string memory _hiddenMetaDataURI) public onlyOwner{
        hiddenMetaDataURI = _hiddenMetaDataURI; 
    }

    function setMintState(bool _publicMint, bool _whitelistMint) public onlyOwner{
        mintState.publicMint = _publicMint; 
        mintState.whitelistMint = _whitelistMint; 
    }

    function withDraw() external onlyOwner{
        (bool success, ) = msg.sender.call{value: address(this).balance}('');
        require(success, "Withdraw failed");    
    }
}
 

 