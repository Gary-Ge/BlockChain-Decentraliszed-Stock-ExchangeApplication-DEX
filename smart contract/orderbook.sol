pragma solidity ^0.8.0;

import "./User_register.sol";
import "./StockExchange.sol";

contract OrderBook {
    struct Order {
        address trader;
        string stockName;
        uint256 price;
        uint256 quantity;
        uint256 timestamp;
    }

    User_register public userRegister;
    StockExchange public stockExchange;

    Order[] public buyOrders;
    Order[] public sellOrders;

    event OrderMatched(
        address buyer,
        address seller,
        string stockName,
        uint256 price,
        uint256 quantity,
        uint256 timestamp
    );

    constructor(address userRegisterAddress, address stockExchangeAddress) {
        userRegister = User_register(userRegisterAddress);
        stockExchange = StockExchange(stockExchangeAddress);
    }

    function placeBuyOrder(
        string memory stockName,
        uint256 price,
        uint256 quantity
    ) public {
        require(stockExchange.isTrader(msg.sender), "You are not an authorized trader");
        buyOrders.push(
            Order({
                trader: msg.sender,
                stockName: stockName,
                price: price,
                quantity: quantity,
                timestamp: block.timestamp
            })
        );
        matchOrders();
    }

    function placeSellOrder(
        string memory stockName,
        uint256 price,
        uint256 quantity
    ) public {
        require(stockExchange.isTrader(msg.sender), "You are not an authorized trader");
        sellOrders.push(
            Order({
                trader: msg.sender,
                stockName: stockName,
                price: price,
                quantity: quantity,
                timestamp: block.timestamp
            })
        );
        matchOrders();
    }

    function matchOrders() internal {
        // This is a order matching logic that matches the first buy order and the first sell order if their prices match.
        if (buyOrders.length > 0 && sellOrders.length > 0) {
            Order storage buyOrder = buyOrders[0];
            Order storage sellOrder = sellOrders[0];
            if (buyOrder.price >= sellOrder.price) {
                uint256 matchedQuantity = buyOrder.quantity < sellOrder.quantity ? buyOrder.quantity : sellOrder.quantity;
                emit OrderMatched(
                    buyOrder.trader,
                    sellOrder.trader,
                    buyOrder.stockName,
                    buyOrder.price,
                    matchedQuantity,
                    block.timestamp
                );
                buyOrder.quantity -= matchedQuantity;
                sellOrder.quantity -= matchedQuantity;
                if (buyOrder.quantity == 0) {
                    removeBuyOrder(0);
                }
                if (sellOrder.quantity == 0) {
                    removeSellOrder(0);
                }
            }
        }
    }

    function removeBuyOrder(uint256 index) internal {
        require(index < buyOrders.length, "Index out of bounds");
        for (uint256 i = index; i < buyOrders.length - 1; i++) {
            buyOrders[i] = buyOrders[i + 1];
        }
        buyOrders.pop();
    }

    function removeSellOrder(uint256 index) internal {
        require(index < sellOrders.length, "Index out of bounds");
        for (uint256 i = index; i < sellOrders.length - 1; i++) {
            sellOrders[i] = sellOrders[i + 1];
        }
        sellOrders.pop();
    }
}
