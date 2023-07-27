// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "./User_register.sol"; // make sure the path is correct

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}


contract SingleSwap {
    address public constant routerAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);
    address public constant LINK = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address public constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

    IERC20 public linkToken = IERC20(LINK);

    // Reference to User_register contract
    User_register public userRegister;

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

    constructor(address _userRegisterAddress) {
        userRegister = User_register(_userRegisterAddress);
    }


    function getLinkBalance(address userAddress) public view returns (uint256) {
    return linkToken.balanceOf(userAddress);
}

    function getWethBalance(address userAddress) public view returns (uint256) {
        IERC20 wethToken = IERC20(WETH);
        return wethToken.balanceOf(userAddress);
    }


    function swapExactInputSingleLinkToWeth(uint256 amountIn) external returns (uint256 amountOut) {
        linkToken.approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: LINK,
            tokenOut: WETH,
            fee: poolFee,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        amountOut = swapRouter.exactInputSingle(params);
    }
    function swapExactInputSingleWethToLink(uint256 amountIn) external returns (uint256 amountOut) {
        IERC20 wethToken = IERC20(WETH);
        wethToken.approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH,
            tokenOut: LINK,
            fee: poolFee,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        amountOut = swapRouter.exactInputSingle(params);
    }
    function swapExactOutputSingleLinkToWeth(uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {
        linkToken.approve(address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
            tokenIn: LINK,
            tokenOut: WETH,
            fee: poolFee,
            recipient: address(this),
            deadline: block.timestamp,
            amountOut: amountOut,
            amountInMaximum: amountInMaximum,
            sqrtPriceLimitX96: 0
        });
    
        amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < amountInMaximum) {
            linkToken.approve(address(swapRouter), 0);
            linkToken.transfer(address(this), amountInMaximum - amountIn);
        }
    }
    function swapExactOutputSingleWethToLink(uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {
    IERC20 wethToken = IERC20(WETH);
    wethToken.approve(address(swapRouter), amountInMaximum);

    ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
        tokenIn: WETH,
        tokenOut: LINK,
        fee: poolFee,
        recipient: address(this),
        deadline: block.timestamp,
        amountOut: amountOut,
        amountInMaximum: amountInMaximum,
        sqrtPriceLimitX96: 0
    });

    amountIn = swapRouter.exactOutputSingle(params);

    if (amountIn < amountInMaximum) {
        wethToken.approve(address(swapRouter), 0);
        wethToken.transfer(msg.sender, amountInMaximum - amountIn);
    }
}
}
