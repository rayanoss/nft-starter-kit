const NerdsAddress = "0xA9cfF12E7EC65b27Eb1c34FcBdB681547bE28b9E";
const NerdsABI = [
    "function getSaleState() public view returns(bool publicMint, bool whitelistMint)", 
    "function mintNerds(uint8 _quantity, bytes32[] calldata _merkleProof) public payable"
]; 

const provider = new ethers.providers.Web3Provider(window.ethereum);
let signer; 
const nerdsContractProvider = new ethers.Contract(NerdsAddress, NerdsABI, provider);

async function connectWallet(){
    await provider.send("eth_requestAccounts", []);
    signer = await provider.getSigner();
    setConnectBtnValue(signer)
}

async function getMintingState() {
    let titleMinting = document.querySelector('.title_minting');
    const saleState = await nerdsContractProvider.getSaleState(); 
    
    if(!saleState.publicMint && !saleState.whitelistMint){
        titleMinting.innerHTML = 'MINTING WILL SOON BE OPEN'
    }else if(!saleState.publicMint && saleState.whitelistMint){
        titleMinting.innerHTML = 'MINTING IS AVAILABLE TO WHITELISTED USERS'
    }
}

async function mintNerds(){
    if(!signer){
        connectWallet();
    }
    try {
        let nerdsContractSigner = new ethers.Contract(NerdsAddress, NerdsABI, signer);
        let mintAmount = document.querySelector('.minting_counter');
        let address = await signer.getAddress();
        const merkleProof = merkleTree.getHexProof(keccak256(address))
        const response = await nerdsContractSigner.mintNerds(mintAmount.value,merkleProof,{
            value: ethers.utils.parseEther((3 * mintAmount.value).toString())
        });
        console.log('response: ', response); 
    } catch (error) {
        console.log(error)
    }
}

async function setConnectBtnValue(){
    let connectButton = document.querySelector('.nav_button_connect');
    if(signer){
       let address = await signer.getAddress();
       connectButton.innerHTML = address.slice(0, 10) + '...';
    }else{
        connectButton.innerHTML = 'CONNECT'; 
    }
      
}


window.addEventListener('load', () => {
    getMintingState();
    connectWallet();
})
