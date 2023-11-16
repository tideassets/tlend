// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.20;

import "../../../interfaces/uniswap/IUniswapV2Pair.sol";
import "./FixedPoint.sol";

// library with helper methods for oracles that are concerned with computing average prices
library UniswapV2OracleLibrary {
	using FixedPoint for *;

	// helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
	function currentBlockTimestamp() internal view returns (uint32) {
		return uint32(block.timestamp % 2 ** 32);
	}

	// produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
	function currentCumulativePrices(
		address pair
	) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
		blockTimestamp = currentBlockTimestamp();
		price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
		price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();

		// if time has elapsed since the last update on the pair, mock the accumulated price values
		(uint256 reserve0, uint256 reserve1, uint256 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
		if (blockTimestampLast != blockTimestamp) {
			// subtraction overflow is desired
			uint256 timeElapsed = uint(blockTimestamp) - blockTimestampLast;
			// addition overflow is desired
			// counterfactual
			price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
			// counterfactual
			price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
		}
	}
}
