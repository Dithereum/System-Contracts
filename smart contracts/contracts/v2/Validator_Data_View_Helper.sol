// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;


interface InterfaceValidator {
    enum Status {
        // validator not exist, default status
        NotExist,
        // validator created
        Created,
        // anyone has staked for the validator
        Staked,
        // validator's staked coins < MinimalStakingCoin
        Unstaked,
        // validator is jailed by system(validator have to repropose)
        Jailed
    }
    struct Description {
        string moniker;
        string identity;
        string website;
        string email;
        string details;
    }
    function getTopValidators() external view returns(address[] memory);
    function validatorInfo(address val) external view returns(address payable, Status, uint256, Description memory,uint256 ,uint256 ,uint256  ,uint256 ,uint256);
    function getValidatorInfo(address val)external view returns(address[]memory);
    function getMasterVoterInfo(address master)external view returns(address[]memory);
    function totalStake() external view returns(uint256);
    function masterVoterInfo(address masterVoter) external view returns(address,uint256,uint256);
    function withdrawableReward(address validator, address _user) external view returns(uint256);
    function staked(address staker, address validator) external view returns(uint256, uint256, uint256, uint256);
    function stakedMaster(address staker, address masterVoter) external view returns(uint256, uint256, uint256, uint256);
    function totalsupply() external view returns(uint256);
    function StakingLockPeriod() external view returns(uint64);



}





contract ValidatorHelper {

    InterfaceValidator public valContract = InterfaceValidator(0x01a0cd85058881Ed08436E0cdF2664e3Df80Bd40);
    
  

    function getAllValidatorInfo() external view returns (uint256 totalValidatorCount,uint256 totalStakedCoins,address[] memory,InterfaceValidator.Status[] memory,uint256[] memory,string[] memory,string[] memory)
    {
        address[] memory highestValidatorsSet = valContract.getTopValidators();
       
        uint256 totalValidators = highestValidatorsSet.length;
        InterfaceValidator.Status[] memory statusArray = new InterfaceValidator.Status[](totalValidators);
        uint256[] memory coinsArray = new uint256[](totalValidators);
        string[] memory identityArray = new string[](totalValidators);
        string[] memory websiteArray = new string[](totalValidators);
        
        for(uint8 i=0; i < totalValidators; i++){
            (, InterfaceValidator.Status status, uint256 coins, InterfaceValidator.Description memory description, , , , , ) = valContract.validatorInfo(highestValidatorsSet[i]);
            
            
            statusArray[i] = status;
            coinsArray[i] = coins;
            identityArray[i] = description.identity;
            websiteArray[i] = description.website;
            
        }
        return(totalValidators, valContract.totalStake(), highestValidatorsSet, statusArray, coinsArray, identityArray, websiteArray);
    
    
    }

    



    function validatorSpecificInfo1(address validatorAddress, address user) external view returns(string memory identityName, string memory website, string memory otherDetails, uint256 withdrawableRewards, uint256 stakedCoins, uint256 waitingBlocksForUnstake ){
        
        (, , , InterfaceValidator.Description memory description, , , , , ) = valContract.validatorInfo(validatorAddress);
                
        
        uint256 unstakeBlock;

        (stakedCoins, unstakeBlock, , ) = valContract.staked(user,validatorAddress);
        

        if(unstakeBlock + valContract.StakingLockPeriod() > block.number){
            waitingBlocksForUnstake = (unstakeBlock + valContract.StakingLockPeriod()) - block.number;
        }
        else{
            waitingBlocksForUnstake=0;
        }

        uint256 yy=0;
         yy = valContract.withdrawableReward(validatorAddress,user);

        return(description.identity, description.website, description.details, yy, stakedCoins, waitingBlocksForUnstake) ;
    }


    function validatorSpecificInfo2(address validatorAddress, address user) external view returns(uint256 totalStakedCoins, InterfaceValidator.Status status, uint256 selfStakedCoins, uint256 masterVoters, uint256 stakers, address){
        address[] memory stakersArray;
        address[] memory masterVotersArray;
        (, status, totalStakedCoins, , , , , ,) = valContract.validatorInfo(validatorAddress);

        (selfStakedCoins, , , ) = valContract.staked(validatorAddress,validatorAddress);

        return (totalStakedCoins, status, selfStakedCoins, masterVotersArray.length, stakersArray.length, user);
    }





}