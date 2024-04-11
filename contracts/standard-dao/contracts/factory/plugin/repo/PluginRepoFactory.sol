// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import {PermissionLib} from "../../../core/permission/PermissionLib.sol";
import {createERC1967Proxy} from "../../../utils/Proxy.sol";
import {PluginRepoRegistry} from "./PluginRepoRegistry.sol";
import {PluginRepo} from "./PluginRepo.sol";

/// @title PluginRepoFactory
/// @notice This contract creates `PluginRepo` proxies and registers them on an `PluginRepoRegistry` contract.
contract PluginRepoFactory {
    /// @notice The plugin registry contract.
    PluginRepoRegistry public pluginRepoRegistry;

    /// @notice The address of the `PluginRepo` base contract.
    address public pluginRepoBase;

    /// @notice Initializes the addresses of the `PluginRepo` base contract to proxy to.
    /// @param _pluginRepoRegistry The plugin registry address.
    constructor(PluginRepoRegistry _pluginRepoRegistry) {
        pluginRepoRegistry = _pluginRepoRegistry;
        pluginRepoBase = address(new PluginRepo());
    }

    /// @notice Creates a plugin repository proxy pointing to the `pluginRepoBase` implementation.
    /// @param _initialOwner The plugin maintainer address.
    function createPluginRepo(
        address _initialOwner
    ) external returns (PluginRepo) {
        return _createPluginRepo(_initialOwner);
    }

    /// @notice Creates a `PluginRepo` and publishes an initial version `1.0`.
    /// @param _pluginSetup The plugin factory contract associated with the plugin version.
    /// @param _maintainer The maintainer of the plugin repo. This address has permission to update metadata, upgrade the repo logic, and manage the repo permissions.
    /// @param _releaseMetadata The release metadata URI.
    /// @param _buildMetadata The build metadata URI.
    /// @dev After the creation of the `PluginRepo` and release of the first version by the factory, ownership is transferred to the `_maintainer` address.
    function createPluginRepoWithFirstVersion(
        address _pluginSetup,
        address _maintainer,
        bytes memory _releaseMetadata,
        bytes memory _buildMetadata
    ) external returns (PluginRepo pluginRepo) {
        // Sets `address(this)` as initial owner which is later replaced with the maintainer address.
        pluginRepo = _createPluginRepo(address(this));

        pluginRepo.createVersion(1, _pluginSetup, _buildMetadata, _releaseMetadata);

        // Setup permissions and transfer ownership from `address(this)` to `_maintainer`.
        _setPluginRepoPermissions(pluginRepo, _maintainer);
    }

    /// @notice Set the final permissions for the published plugin repository maintainer. All permissions are revoked from the plugin factory and granted to the specified plugin maintainer.
    /// @param pluginRepo The plugin repository instance just created.
    /// @param maintainer The plugin maintainer address.
    /// @dev The plugin maintainer is granted the `MAINTAINER_PERMISSION_ID`, `UPGRADE_REPO_PERMISSION_ID`, and `ROOT_PERMISSION_ID`.
    function _setPluginRepoPermissions(PluginRepo pluginRepo, address maintainer) internal {
        // Set permissions on the `PluginRepo`s `PermissionManager`
        PermissionLib.SingleTargetPermission[]
            memory items = new PermissionLib.SingleTargetPermission[](6);

        bytes32 rootPermissionID = pluginRepo.ROOT_PERMISSION_ID();
        bytes32 maintainerPermissionID = pluginRepo.MAINTAINER_PERMISSION_ID();
        bytes32 upgradePermissionID = pluginRepo.UPGRADE_REPO_PERMISSION_ID();

        // Grant the plugin maintainer all the permissions required
        items[0] = PermissionLib.SingleTargetPermission(
            PermissionLib.Operation.Grant,
            maintainer,
            maintainerPermissionID
        );
        items[1] = PermissionLib.SingleTargetPermission(
            PermissionLib.Operation.Grant,
            maintainer,
            upgradePermissionID
        );
        items[2] = PermissionLib.SingleTargetPermission(
            PermissionLib.Operation.Grant,
            maintainer,
            rootPermissionID
        );

        // Revoke permissions from the plugin repository factory (`address(this)`).
        items[3] = PermissionLib.SingleTargetPermission(
            PermissionLib.Operation.Revoke,
            address(this),
            rootPermissionID
        );
        items[4] = PermissionLib.SingleTargetPermission(
            PermissionLib.Operation.Revoke,
            address(this),
            maintainerPermissionID
        );
        items[5] = PermissionLib.SingleTargetPermission(
            PermissionLib.Operation.Revoke,
            address(this),
            upgradePermissionID
        );

        pluginRepo.applySingleTargetPermissions(address(pluginRepo), items);
    }

    /// @notice Internal method creating a `PluginRepo` via the [ERC-1967](https://eips.ethereum.org/EIPS/eip-1967) proxy pattern from the provided base contract.
    /// @param _initialOwner The initial owner address.
    function _createPluginRepo(
        address _initialOwner
    ) internal returns (PluginRepo pluginRepo) {
        pluginRepo = PluginRepo(
            createERC1967Proxy(
                pluginRepoBase,
                abi.encodeWithSelector(PluginRepo.initialize.selector, _initialOwner)
            )
        );

        pluginRepoRegistry.registerPluginRepo(address(pluginRepo));
    }
}