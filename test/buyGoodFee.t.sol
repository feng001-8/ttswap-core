// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {MyToken} from "../src/ERC20.sol";
import "../Contracts/MarketManager.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {S_GoodKey, S_ProofKey, S_Ralate} from "../Contracts/libraries/L_Struct.sol";
import {L_ProofIdLibrary, L_Proof} from "../Contracts/libraries/L_Proof.sol";
import {L_GoodIdLibrary, L_Good} from "../Contracts/libraries/L_Good.sol";
import {T_BalanceUINT256, toBalanceUINT256} from "../Contracts/libraries/L_BalanceUINT256.sol";

import {L_GoodConfigLibrary} from "../Contracts/libraries/L_GoodConfig.sol";
import {L_MarketConfigLibrary} from "../Contracts/libraries/L_MarketConfig.sol";

import {GoodUtil} from "./util/GoodUtil.sol";

contract buyGoodFee is BaseSetup {
    using L_MarketConfigLibrary for uint256;
    using L_GoodConfigLibrary for uint256;
    using L_GoodIdLibrary for S_GoodKey;
    using L_ProofIdLibrary for S_ProofKey;

    uint256 metagood;
    uint256 normalgoodusdt;
    uint256 normalgoodeth;

    function setUp() public override {
        BaseSetup.setUp();
        initmetagood();
        normalgoodusdt = initNormalGood(address(usdt));
    }

    function initmetagood() public {
        vm.startPrank(marketcreator);
        btc.mint(marketcreator, 1000000000);
        btc.approve(address(market), 1000000000);

        uint256 _goodConfig = (2 ** 255) +
            8 *
            2 ** 246 +
            8 *
            2 ** 240 +
            8 *
            2 ** 233 +
            8 *
            2 ** 226;

        console2.log("btc", btc.balanceOf(marketcreator));
        market.initMetaGood(
            address(btc),
            toBalanceUINT256(20000000, 20000000),
            _goodConfig
        );
        metagood = 1;
        console2.log(1, _goodConfig);
        console2.log(2, (1 * 10 ** 18) * 2 ** 128 + 3100 * 10 ** 6);
        console2.log(3, 10000 * 10 ** 6);
        console2.log(address(0));

        uint256 _marketConfig = (50 << 250) +
            (5 << 244) +
            (10 << 238) +
            (15 << 232) +
            (20 << 226) +
            (20 << 220);
        console2.log("marketconfig", _marketConfig);

        market.setMarketConfig(_marketConfig);

        vm.stopPrank();
    }

    function initNormalGood(address token) public returns (uint256 normalgood) {
        vm.startPrank(users[3]);
        btc.mint(users[3], 1000000000);
        btc.approve(address(market), 1000000000);

        MyToken(token).mint(users[3], 100000000000);
        MyToken(token).approve(address(market), 100000000000);
        uint256 _goodConfig = 0 *
            8 *
            2 ** 246 +
            8 *
            2 ** 240 +
            8 *
            2 ** 233 +
            8 *
            2 ** 226;

        market.initGood(
            metagood,
            toBalanceUINT256(20000000, 20000000),
            token,
            _goodConfig,
            msg.sender
        );
        normalgood = 2;
        vm.stopPrank();
    }

    function testBuyGood() public {
        vm.startPrank(users[6]);
        deal(address(usdt), users[6], 1000000000, false);
        deal(address(btc), users[6], 1000000000, false);
        deal(address(usdt), address(1), 1000000000, false);
        deal(address(btc), address(1), 1000000000, false);
        deal(address(usdt), address(marketcreator), 1000000000, false);
        deal(address(btc), address(marketcreator), 1000000000, false);
        deal(address(usdt), address(market), 1000000000, false);
        deal(address(btc), address(market), 1000000000, false);
        usdt.approve(address(market), 100000000);
        L_Good.S_GoodTmpState memory s1 = market.getGoodState(metagood);
        GoodUtil.showGood(s1);
        L_Good.S_GoodTmpState memory s2 = market.getGoodState(normalgoodusdt);
        GoodUtil.showGood(s2);

        uint128 goodid2Quanitity_;
        uint128 goodid2FeeQuanitity_;
        snapStart("buygood with fee without chips first");
        (goodid2Quanitity_, goodid2FeeQuanitity_) = market.buyGood(
            normalgoodusdt,
            metagood,
            1000000,
            T_BalanceUINT256.unwrap(toBalanceUINT256(2, 1)),
            false,
            address(1)
        );
        snapEnd();
        console2.log(goodid2Quanitity_, goodid2FeeQuanitity_);
        s1 = market.getGoodState(metagood);
        s2 = market.getGoodState(normalgoodusdt);
        GoodUtil.showGood(s1);
        GoodUtil.showGood(s2);

        snapStart("buygood with fee without chips second");
        (goodid2Quanitity_, goodid2FeeQuanitity_) = market.buyGood(
            normalgoodusdt,
            metagood,
            1000000,
            T_BalanceUINT256.unwrap(toBalanceUINT256(2, 1)),
            false,
            address(1)
        );
        snapEnd();
    }
}
