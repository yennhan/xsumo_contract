// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract XSumo is
    Initializable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    ERC721BurnableUpgradeable,
    UUPSUpgradeable
{
    bool private initialized;
    uint256 public maxSupply;
    address public creatorAddress;
    string public creatorName;
    uint256 public cost;
    uint256 public gigaCost;
    uint256 public presaleCost;
    uint256 public presaleAmount;
    uint256 public maxMintAmount;
    string public normalSerumURI;
    string public gigaSerumURI;
    uint256 public gigaSales;
    mapping(uint256 => bool) public fused;
    mapping(uint256 => address) public firstFuseAddress;
    mapping(address => bool) public whitelisted;
    mapping(address => bool) public presaleWallets;
    mapping(address => bool) public airdropList;
    uint256 public x;

    function initialize(uint256 _x) public initializer {
        require(!initialized, "Contract instance has already been initialized");
        initialized = true;
        __ERC721_init("XSUMO", "XSUMO");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __Ownable_init();
        __ERC721Burnable_init();
        __UUPSUpgradeable_init();
        x = _x;
        cost = 2000000000000000000000 wei;
        presaleCost = 1800000000000000000000 wei;
        gigaCost = 20000000000000000000000 wei;
        presaleAmount = 3000;
        maxSupply = 10000;
        maxMintAmount = 5000;
        creatorAddress = 0xa359F9524a4986B5dc180feDFaC9c0ED941b0615;
        creatorName = "Kapasuso";
        normalSerumURI = "ipfs://QmcWf3QGEmcaq1cv71XwoH4yQMjxqeu7KAwVM2JqJArwAa";
        gigaSerumURI = "ipfs://QmNTSEHGfSfKgsax88Ev6MnMh29Zkr94JAjFJmePVCShwj";
        gigaSales = 0;
        for (uint256 i = 1; i <= 10000; i++) {
            fused[i] = false;
        }
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function updateCreatorAdd(address _creatorAddress) public onlyOwner {
        creatorAddress = _creatorAddress;
    }

    function updateGigaSerumURI(string memory _gigaSerum) public onlyOwner {
        gigaSerumURI = _gigaSerum;
    }

    function updateNormalSerumURI(string memory _normalSerum) public onlyOwner {
        normalSerumURI = _normalSerum;
    }
    function updateTokenURI(uint256 tokenId,string memory _uri) public onlyOwner {
        _setTokenURI(tokenId, _uri);
    }
    // function updateSumoAddress(address memory _sumoAddress) public onlyOwner {
    //     sumoAddress = _sumoAddress;
    // }

    // function getSumoAddress() public view returns (address memory name) {
    //     return sumoAddress;
    // }
    function getTokenFuseInfo(uint256 tokenId) public view returns (bool name) {
        return fused[tokenId];
    }
    function getCreatorName() public view returns (string memory name) {
        return creatorName;
    }

    function getGigaSerumURI() public view returns (string memory name) {
        return gigaSerumURI;
    }

    function getNormalSerumURI() public view returns (string memory name) {
        return normalSerumURI;
    }

    function getGigaSales() public view returns (uint256 name) {
        return gigaSales;
    }
    function getPreSalesWallet(address _preSaleAddress) public view returns (bool name) {
        return presaleWallets[_preSaleAddress];
    }

    function getFirstMinterInfo(uint256 tokenId)
        public
        view
        returns (address firstMinter)
    {
        return firstFuseAddress[tokenId];
    }

    function safeGigaMint(address _to, uint256 tokenId) public payable {
        require(tokenId >= 1);
        require(tokenId <= 10);
        require(msg.value >= gigaCost);
        uint256 comission;
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, gigaSerumURI);
        comission = ((gigaCost * 500) / 10000);
        gigaSales = gigaSales + 1;
        (bool success, ) = payable(creatorAddress).call{value: comission}("");
        require(success);
    }

    function safeMint(address _to, uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        require(_mintAmount > 0);
        require(_mintAmount <= maxMintAmount);
        require(supply + _mintAmount <= maxSupply);
        uint256 comission;
        if (msg.sender != owner()) {
            if (whitelisted[msg.sender] != true) {
                if (presaleWallets[msg.sender] != true) {
                    //general public
                    require(msg.value >= cost * _mintAmount);
                    comission = (((cost * _mintAmount) * 250) / 10000);
                } else {
                    //presale
                    require(msg.value >= presaleCost * _mintAmount);
                    comission = (((presaleCost * _mintAmount) * 250) / 10000);
                }
            }
        }
        if (gigaSales != 10) {
            for (uint256 i = 1; i <= _mintAmount; i++) {
                _safeMint(_to, supply + 10 + i - gigaSales);
                _setTokenURI(supply + 10 + i - gigaSales, normalSerumURI);
                fused[supply + 10 + i - gigaSales] = false;
            }
        } else {
            for (uint256 i = 1; i <= _mintAmount; i++) {
                _safeMint(_to, supply + i);
                _setTokenURI(supply + i, normalSerumURI);
                fused[supply + i] = false;
            }
        }
        (bool success, ) = payable(creatorAddress).call{value: comission}("");
        require(success);
        if(presaleWallets[msg.sender]==true){
            presaleWallets[msg.sender]=false;
        }
    }

    function fuse(uint256 _burnTokenId, string memory uri) public {
        require(_burnTokenId > 10, "Token ID has to be normal serum");
        require(msg.sender ==ownerOf(_burnTokenId),"You are not the owner of the token");
        _setTokenURI(_burnTokenId, uri);
        fused[_burnTokenId] = true;
        firstFuseAddress[_burnTokenId] = msg.sender;
    }

    function fuseGiga(uint256 _burnTokenId, string memory uri) public {
        require(_burnTokenId < 11, "Token ID has to be Giga serum");
        require(msg.sender ==ownerOf(_burnTokenId),"You are not the owner of the token");
        _setTokenURI(_burnTokenId, uri);
        fused[_burnTokenId] = true;
        firstFuseAddress[_burnTokenId] = msg.sender;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        whenNotPaused
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function whitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = true;
    }

    function removeWhitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = false;
    }

    function addPresaleUser(address _user) public onlyOwner {
        presaleWallets[_user] = true;
    }

    function add100PresaleUsers(address[100] memory _users) public onlyOwner {
        for (uint256 i = 0; i < 100; i++) {
            presaleWallets[_users[i]] = true;
        }
    }

    function removePresaleUser(address _user) public onlyOwner {
        presaleWallets[_user] = false;
    }

    function setPresaleCost(uint256 _newCost) public onlyOwner {
        presaleCost = _newCost;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setGigaCost(uint256 _newGigaCost) public onlyOwner {
        gigaCost = _newGigaCost;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Failure to send");
    }
}
