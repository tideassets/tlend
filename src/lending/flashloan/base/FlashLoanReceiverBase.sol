// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IFlashLoanReceiver} from "../interfaces/IFlashLoanReceiver.sol";
import {ILendingPoolAddressesProvider} from "../../../interfaces/ILendingPoolAddressesProvider.sol";
import {ILendingPool} from "../../../interfaces/ILendingPool.sol";

abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {
	using SafeERC20 for IERC20;
	using Math for uint256;

	ILendingPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
	ILendingPool public immutable LENDING_POOL;

	constructor(ILendingPoolAddressesProvider provider) {
		ADDRESSES_PROVIDER = provider;
		LENDING_POOL = ILendingPool(provider.getLendingPool());
	}
}
