// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.20;

interface IWETH {
	function deposit() external payable;

	function transfer(address to, uint256 value) external returns (bool);

	function withdraw(uint256) external;

	function balanceOf(address) external returns (uint256);
}
