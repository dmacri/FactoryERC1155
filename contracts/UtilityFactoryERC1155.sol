// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./EdgeNodeItems.sol";

contract UtilityFactoryERC1155 {

    enum SensorTypes {
        TEMPERATURE,
        HUMIDITY,
        PRESSURE             
    }
  
 
    mapping(uint256 => address) public indexToContract; //index to contract address mapping
    mapping(uint256 => address) public indexToOwner; //index to ERC1155 owner 
   /*
    Helper functions below retrieve contract data given an ID or name and index in the tokens array.
    */
    function getSensorTypesEnumKeyByValue (SensorTypes  _sensorTypes) public pure returns (string memory) {
        if (SensorTypes.TEMPERATURE == _sensorTypes) return "TEMPERATURE";
        if (SensorTypes.HUMIDITY == _sensorTypes) return "HUMIDITY";
        if (SensorTypes.PRESSURE == _sensorTypes) return "PRESSURE";
    revert("Sensor not specified");
    }
    function getNameOfSensor(SensorTypes _sensorTypes, string memory _name) external pure returns (string memory) {
        return string(abi.encodePacked(getSensorTypesEnumKeyByValue(_sensorTypes),'_',_name));
    }

    function getCountERC1155byIndex(uint256 _index, uint256 _id, EdgeNodeItems[] calldata tokens) external view returns (uint amount) {
        return tokens[_index].balanceOf(indexToOwner[_index], _id);
    }

    function getCountERC1155byName(uint256 _index, string calldata _name, EdgeNodeItems[] calldata tokens) external view returns (uint amount) {
        uint id = getIdByName(_index, _name,tokens);
        return tokens[_index].balanceOf(indexToOwner[_index], id);
    }

    function getIdByName(uint _index, string memory _name, EdgeNodeItems[] calldata tokens) public view returns (uint) {
        return tokens[_index].nameToId(_name);
    }

    function getNameById(uint _index, uint _id, EdgeNodeItems[] calldata tokens) public view returns (string memory) {
        return tokens[_index].idToName(_id);
    }
     function getERC1155byIndexAndId(uint _index, uint _id, EdgeNodeItems[] calldata tokens)
        public
        view
        returns (
            address _contract,
            address _owner,
            string memory _uri,
            uint supply
        )
    {
        EdgeNodeItems token = tokens[_index];
        return (address(token), token.owner(), token.uri(_id), token.balanceOf(indexToOwner[_index], _id));
    }
}