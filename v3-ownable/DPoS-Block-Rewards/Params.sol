// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Params {
    bool public initialized;

    // System contracts
    address payable
        public constant ValidatorContractAddr = payable(0x000000000000000000000000000000000000f000);
    address
        public constant PunishContractAddr = 0x000000000000000000000000000000000000F001;
    address
        public constant ProposalAddr = 0x000000000000000000000000000000000000F002;

    // System params
    uint16 public  MaxValidators = 21;
    // Validator have to wait StakingLockPeriod blocks to withdraw staking
    uint64 public constant StakingLockPeriod = 86400;
    // Validator have to wait WithdrawProfitPeriod blocks to withdraw his profits
    //uint64 public constant WithdrawProfitPeriod = 28800;
    uint256 public  MinimalStakingCoin = 32 ether;
    // minimum initial staking to become a validator
    uint256 public  minimumValidatorStaking = 10000 ether;


    // percent distrubution of Gas Fee earned by validator 100000 = 100%
    uint public  stakerPartPercent = 45000;          //45%
    uint public  validatorPartPercent = 5000;        //5%
    uint public  burnPartPercent = 0;                //0%
    uint public  contractPartPercent = 50000;        //50%
    uint public  burnStopAmount = 100000 ether;      // after 100,000 coins burn, it will stop burning
    uint public totalBurnt;
    uint256 public extraRewardsPerBlock = 1 ether;  //  extra rewards will be added for distrubution
    uint256 public rewardFund ;
    uint256 public totalRewards;



    modifier onlyMiner() {
        require(msg.sender == block.coinbase, "Miner only");
        _;
    }

    modifier onlyNotInitialized() {
        require(!initialized, "Already initialized");
        _;
    }

    modifier onlyInitialized() {
        require(initialized, "Not init yet");
        _;
    }

    modifier onlyPunishContract() {
        require(msg.sender == PunishContractAddr, "Punish contract only");
        _;
    }

    modifier onlyBlockEpoch(uint256 epoch) {
        require(block.number % epoch == 0, "Block epoch only");
        _;
    }

    modifier onlyValidatorsContract() {
        require(
            msg.sender == ValidatorContractAddr,
            "Validators contract only"
        );
        _;
    }

    modifier onlyProposalContract() {
        require(msg.sender == ProposalAddr, "Proposal contract only");
        _;
    }
}
