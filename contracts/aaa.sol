// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract EdgeNodeItems is ERC1155 , Ownable{
    string[] public names; //set string array of names
    uint[] public ids; //set uint array of ids
    string public baseMetadataURI; //the token metadata URI
    string public name; //set the token mame
    uint public mintFee = 0 wei; //mintfee, 0 by default. only used in mint function, not batch.
   
 
    mapping(string => uint) public nameToId; //name to id mapping
    mapping(uint => string) public idToName; //id to name mapping

    /*
    constructor is executed when the factory contract calls its own deployERC1155 method
    */
    constructor(string memory _contractName, string memory _uri, string[] memory _names, uint[] memory _ids) ERC1155(_uri) {
        names = _names;
        ids = _ids;
        createMapping();
        setURI(_uri);
        baseMetadataURI = _uri;
        name = _contractName;
        transferOwnership(tx.origin);
    }   
  
    function createMapping() private {
        for (uint id = 0; id < ids.length; id++) {
            nameToId[names[id]] = ids[id];
            idToName[ids[id]] = names[id];
        }
    }
 
    function uri(uint256 _tokenid) override public view returns (string memory) {
        return string(
            abi.encodePacked(
                baseMetadataURI,
                Strings.toString(_tokenid),".json"
            )
        );
    }

    function getNames() public view returns(string[] memory) {
        return names;
    }

    /*
    used to change metadata, only owner access
    */
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /*
    set a mint fee. only used for mint, not batch.
    */
    function setFee(uint _fee) public onlyOwner {
        mintFee = _fee;
    }

    /*
    mint(address account, uint _id, uint256 amount)

    account - address to mint the token to
    _id - the ID being minted
    amount - amount of tokens to mint
    */
    function mint(address account, uint _id, uint256 amount) 
        public payable returns (uint)
    {
        require(msg.value == mintFee);
        _mint(account, _id, amount, "");
        return _id;
    }

    /*
    mintBatch(address to, uint256[] memory _ids, uint256[] memory amounts, bytes memory data)

    to - address to mint the token to
    _ids - the IDs being minted
    amounts - amount of tokens to mint given ID
    bytes - additional field to pass data to function
    */
    function mintBatch(address to, uint256[] memory _ids, uint256[] memory amounts, bytes memory data)
        public
    {
        _mintBatch(to, _ids, amounts, data);
    }

        /*
    safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data)

    from - address owner of the token 
    to - address to send the token to
    ids - the IDs onf tokens
    amount - amount of token.
    data -number of data in bytes
     */
  function safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data) public virtual override {
    require(
        from == _msgSender() || isApprovedForAll(from, _msgSender()),
        "ERC1155: transfer caller is not owner nor approved"
    );
    _safeBatchTransferFrom(from, to, ids, amounts, data);
}


}