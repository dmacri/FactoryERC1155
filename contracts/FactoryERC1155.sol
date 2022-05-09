// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./EdgeNodeItems.sol";
import "./UtilityFactoryERC1155.sol";

interface  IUtilityFactoryERC1155{
   function getSensorTypesEnumKeyByValue (UtilityFactoryERC1155.SensorTypes  _sensorTypes) external pure returns (string memory) ;
   function getNameOfSensor(UtilityFactoryERC1155.SensorTypes _sensorTypes, string memory _name) external pure returns (string memory);
   function getCountERC1155byIndex(uint256 _index, uint256 _id,EdgeNodeItems[] calldata tokens) external view returns (uint amount);
   function getCountERC1155byName(uint256 _index, string calldata _name,EdgeNodeItems[] calldata tokens) external view returns (uint amount);
   function getIdByName(uint _index, string memory _name,EdgeNodeItems[] calldata tokens) external view returns (uint);
   function getNameById(uint _index, uint _id,EdgeNodeItems[] calldata tokens) external view returns (string memory);
}

contract FactoryERC1155 {
    EdgeNodeItems[] public tokens; //an array that contains different ERC1155 tokens deployed
    mapping(address => EdgeNodeItems[]) public nodeAddressToListOwnerSensor; // index of Fogs node
    mapping(uint256 => address) public indexToContract; //index to contract address mapping
    mapping(uint256 => address) public indexToOwner; //index to ERC1155 owner 
    event ERC1155Created(address owner, address tokenContract); //emitted when ERC1155 token is deployed
    event ERC1155Minted(address owner, address tokenContract, uint amount); //emmited when ERC1155 token is minted
    address private constant UtilityFactoryERC1155ContractAddress = 0x20B1a7ED8e2a22d4E4b6a5F4b6751eF62dFa90C0;
    /*
    deployERC1155 - deploys a ERC1155 token with given parameters - returns deployed address
    _contractName - name of our ERC1155 token
    _uri - URI resolving to our hosted metadata
    _ids - IDs the ERC1155 token should contain
    _name - Names each ID should map to. Case-sensitive.
    */
    function deployERC1155(string memory _contractName, string memory _uri, uint[] memory _ids, string[] memory _names,address nodeFog) public returns (address) {
        EdgeNodeItems t = new EdgeNodeItems(_contractName, _uri, _names, _ids);
        tokens.push(t);
        indexToContract[tokens.length - 1] = address(t);
        indexToOwner[tokens.length - 1] = tx.origin;
        nodeAddressToListOwnerSensor[nodeFog]=tokens;
        emit ERC1155Created(msg.sender,address(t));
        return address(t);
    }
    /*
    mintERC1155 - mints a ERC1155 token with given parameters
    _index - index position in our tokens array - represents which ERC1155 you want to interact with
    _name - Case-sensitive. Name of the token (this maps to the ID you created when deploying the token)
    _sensorTypes - sensor type example:{}
    _amount - amount of tokens you wish to mint
    */
     function mintERC1155(uint _index, string memory _name,UtilityFactoryERC1155.SensorTypes _sensorTypes ,uint256 amount) public {
        uint id = IUtilityFactoryERC1155(UtilityFactoryERC1155ContractAddress).getIdByName(_index,IUtilityFactoryERC1155(UtilityFactoryERC1155ContractAddress).getNameOfSensor(_sensorTypes,_name),tokens);
        tokens[_index].mint(indexToOwner[_index], id, amount);
        emit ERC1155Minted(tokens[_index].owner(), address(tokens[_index]), amount);
    }
}