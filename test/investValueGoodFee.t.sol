// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {MyToken} from "../src/ERC20.sol";
import "../Contracts/MarketManager.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {S_GoodKey, S_Ralate, S_ProofKey} from "../Contracts/libraries/L_Struct.sol";
import {L_ProofIdLibrary, L_Proof} from "../Contracts/libraries/L_Proof.sol";
import {L_GoodIdLibrary, L_Good} from "../Contracts/libraries/L_Good.sol";
import {T_BalanceUINT256, toBalanceUINT256} from "../Contracts/libraries/L_BalanceUINT256.sol";

import {L_GoodConfigLibrary} from "../Contracts/libraries/L_GoodConfig.sol";
import {L_MarketConfigLibrary} from "../Contracts/libraries/L_MarketConfig.sol";

contract investValueGoodFee is BaseSetup {
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
    }

    function initmetagood() public {
        vm.startPrank(marketcreator);
        deal(address(btc), marketcreator, 100000, false);
        btc.approve(address(market), 30000);
        uint256 _goodconfig = 2 ** 255;
        uint256 _marketConfig = (50 << 250) +
            (5 << 244) +
            (10 << 238) +
            (15 << 232) +
            (20 << 226) +
            (20 << 220);
        market.initMetaGood(
            address(btc),
            toBalanceUINT256(20000, 20000),
            _goodconfig
        );
        metagood = 1;
        market.setMarketConfig(_marketConfig);

        // market.updatetoValueGood(metagood);
        uint256 _goodConfig = 1 * 2 ** 255 + 8 * 2 ** 246 + 8 * 2 ** 240;
        console2.log(_marketConfig.checkAllocate());
        console2.log(_marketConfig.getLiquidFee(), "liqiuid");
        console2.log(_marketConfig.getSellerFee(), "seller");
        console2.log(_marketConfig.getGaterFee(), "gater");
        console2.log(_marketConfig.getReferFee(), "refer");
        console2.log(_marketConfig.getCustomerFee(), "customer");
        console2.log(_marketConfig.getPlatFee(), "plat");
        console2.log(_goodConfig.isvaluegood(), "1");
        console2.log(_goodConfig.getInvestFee(), "2");
        console2.log(_goodConfig.getDisinvestFee(), "3");
        market.updateGoodConfig(metagood, _goodConfig);
        vm.stopPrank();
    }

    function testinvestValueGood(uint256) public {
        vm.startPrank(users[4]);
        deal(
            market.getGoodState(metagood).erc20address,
            users[4],
            100000,
            false
        );
        MyToken(market.getGoodState(metagood).erc20address).approve(
            address(market),
            100000
        );

        snapStart("invest value good with fee first");
        market.investGood(metagood, 0, 20000, address(1));
        snapEnd();
        uint256 p_ = market.proofseq(S_ProofKey(users[4], metagood, 0).toId());
        L_Good.S_GoodTmpState memory aa = market.getGoodState(metagood);
        L_Proof.S_ProofState memory _s = market.getProofState(p_);
        assertEq(_s.state.amount0(), 19984, "proof's value is error");
        assertEq(_s.invest.amount0(), 0, "proof's contruct quantity is error");
        assertEq(_s.invest.amount1(), 19984, "proof's quantity is error");

        assertEq(
            aa.currentState.amount0(),
            39984,
            "currentState's value is error"
        );
        assertEq(
            aa.currentState.amount1(),
            39984,
            "currentState's quantity is error"
        );

        assertEq(
            aa.investState.amount0(),
            39984,
            "investState's value is error"
        );
        assertEq(
            aa.investState.amount1(),
            39984,
            "investState's quantity is error"
        );
        console2.log(
            uint256(aa.feeQunitityState.amount0()),
            uint256(aa.feeQunitityState.amount1())
        );
        assertEq(
            aa.feeQunitityState.amount1(),
            0,
            "feeQunitityState's contruct is error"
        );
        assertEq(
            aa.feeQunitityState.amount0(),
            8,
            "feeQunitityState's feeamount fee is error"
        );

        assertEq(
            uint256(market.getGoodsFee(metagood, users[4])),
            0,
            "customer fee"
        );
        assertEq(
            uint256(market.getGoodsFee(metagood, marketcreator)),
            3,
            "seller fee"
        );
        assertEq(market.getGoodsFee(metagood, address(1)), 5, "gater fee");
        assertEq(market.getGoodsFee(metagood, address(2)), 0, "refer fee");
        snapStart("invest value good with fee second");
        market.investGood(metagood, 0, 200, address(1));
        snapEnd();
        vm.stopPrank();
    }
}
