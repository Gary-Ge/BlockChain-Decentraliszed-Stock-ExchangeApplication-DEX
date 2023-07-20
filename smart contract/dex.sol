// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StockExchange {
    address public manager;
    uint256 public nextTraderId;

    struct Stock {
        string name;
        uint256 quantity;
    }

    struct Trader {
        uint256 traderId;
        mapping(string => uint256) stockBalances;
    }

    mapping(address => Trader) public traders;
    mapping(uint256 => address) public traderIds;
    string[] public stockNames; // 新增股票名称数组

    event TraderAdded(address indexed trader, uint256 traderId);
    event StockIssued(address indexed trader, string stockName, uint256 quantity);
    event StockTransferred(address indexed fromTrader, address indexed toTrader, string stockName, uint256 quantity);

    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    constructor() {
        manager = msg.sender;
        nextTraderId = 1;
    }

    function addTrader(address trader) external onlyManager {
        require(!isTrader(trader), "Trader already exists");
        traders[trader].traderId = nextTraderId;
        traderIds[nextTraderId] = trader;
        nextTraderId++;
        emit TraderAdded(trader, traders[trader].traderId);
    }

    function isTrader(address trader) internal view returns (bool) {
        return traders[trader].traderId != 0;
    }

    function issueStock(string memory stockName, uint256 quantity) external {
        require(isTrader(msg.sender), "You are not an authorized trader");
        require(bytes(stockName).length > 0, "Stock name must not be empty");
        require(quantity > 0, "Stock quantity must be greater than zero");

        traders[msg.sender].stockBalances[stockName] += quantity;
        // 添加股票名称到数组
        if (traders[msg.sender].stockBalances[stockName] == quantity) {
            stockNames.push(stockName);
        }
        emit StockIssued(msg.sender, stockName, quantity);
    }

    function transferStock(address toTrader, string memory stockName, uint256 quantity) external {
        require(isTrader(msg.sender) && isTrader(toTrader), "Both sender and receiver should be authorized traders");
        require(bytes(stockName).length > 0, "Stock name must not be empty");
        require(quantity > 0, "Stock quantity must be greater than zero");
        require(traders[msg.sender].stockBalances[stockName] >= quantity, "Insufficient stock balance");

        traders[msg.sender].stockBalances[stockName] -= quantity;
        traders[toTrader].stockBalances[stockName] += quantity;
        emit StockTransferred(msg.sender, toTrader, stockName, quantity);
    }

    function getStockBalance(string memory stockName) external view returns (uint256) {
        require(isTrader(msg.sender), "You are not an authorized trader");
        return traders[msg.sender].stockBalances[stockName];
    }
function getAllStockNames() external view returns (string[] memory) {
        require(isTrader(msg.sender), "You are not an authorized trader");
        Trader storage trader = traders[msg.sender];

        // 遍历查询账户中持有股票的数量不为0的股票名称
        uint256 numStocks = 0;
        for (uint256 i = 0; i < stockNames.length; i++) {
            string memory stockName = stockNames[i];
            if (trader.stockBalances[stockName] > 0) {
                numStocks++;
            }
        }

        // 存储账户持有的股票名称
        string[] memory ownedStockNames = new string[](numStocks);
        uint256 index = 0;
        for (uint256 i = 0; i < stockNames.length; i++) {
            string memory stockName = stockNames[i];
            uint256 quantity = trader.stockBalances[stockName];
            if (quantity > 0) {
                ownedStockNames[index] = stockName;
                index++;
            }
        }

        return ownedStockNames;
    }
}
