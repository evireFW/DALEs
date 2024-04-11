// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import {IDAO} from "../../core/dao/IDAO.sol";
import {InterfaceBasedRegistry} from "../utils/InterfaceBasedRegistry.sol";

/// @notice This contract provides the possiblity to register a DAO.
contract DAORegistry is InterfaceBasedRegistry {
    /// @notice The ID of the permission required to call the `register` function.
    bytes32 public constant REGISTER_DAO_PERMISSION_ID = keccak256("REGISTER_DAO_PERMISSION");

    /// @notice Emitted when a new DAO is registered.
    /// @param dao The address of the DAO contract.
    /// @param creator The address of the creator.
    event DAORegistered(address indexed dao, address indexed creator);

    /// @dev Used to disallow initializing the implementation contract by an attacker for extra safety.
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the contract.
    /// @param _managingDao the managing DAO address.
    function initialize(
        IDAO _managingDao
    ) external initializer {
        __InterfaceBasedRegistry_init(_managingDao, type(IDAO).interfaceId);
    }

    /// @notice Registers a DAO by its address.
    /// @param dao The address of the DAO contract.
    /// @param creator The address of the creator.
    function register(
        IDAO dao,
        address creator
    ) external auth(REGISTER_DAO_PERMISSION_ID) {
        address daoAddr = address(dao);

        _register(daoAddr);

        emit DAORegistered(daoAddr, creator);
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZepplins guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[49] private __gap;
}