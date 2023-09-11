pragma solidity ^0.8.17;
import "./CNBCNews.sol";
contract FakeNews is CNBCNews {
    // Model a Candidate
    struct News {
        uint id;
        string name;
        uint voteCount;
        uint upVote;
        uint downVote;
        string verdict;
    }
    
    address public contractOwner;
    // Store accounts that have voted
    mapping(address => uint[]) public voters;

    mapping(uint => News) public newses;
    mapping(uint => address[]) public newsVoterMappings;
    uint public newsCount;
    uint public rewardValue;
    uint public incrementToken;
    event votedEvent (
        uint indexed _newsId
    );

modifier validVoter(uint newsId ,address sender) {
    bool isValid = true;
    uint[] memory votes = voters[sender];

    if( votes.length > 0) {        
        for(uint i=0;i<votes.length;i++){
            if(votes[i] == newsId) {
                isValid = false;
            }
        }
    }
    require(isValid,"Not a Valid Voter");
    _;
}

modifier onlyOwn {
    require(msg.sender == contractOwner,"Not An aowner ");
    _;
}
   
    constructor () {
        contractOwner = msg.sender;
        rewardValue = 1 * 10 ** decimals();
        incrementToken =  10000 * 10 ** decimals();
        addNews("Trump lost in the Election");
        addNews("Russia Plans to drop Nuclear weapons on Ukraine");
        addNews("India lost the T-20 World Cup");
        addNews("Canadian people lose thier trust in their Prime Minister");
    }

    function addNews (string memory _name) private {
        newsCount ++;
        newses[newsCount] = News(newsCount, _name, 0,0,0,"Tentaive News");
    }

 function vote (uint _newsId) validVoter(_newsId,msg.sender) public {

        voters[msg.sender].push(_newsId);
        newsVoterMappings[_newsId].push(msg.sender);

        // update news vote Count
        newses[_newsId].voteCount ++;
        newses[_newsId].upVote ++;
        result(_newsId);        // trigger voted event
        emit votedEvent(_newsId);
    }


    function incentivizeVoter(uint _newsId) onlyOwn public {
        uint balance = balanceOf(contractOwner);
        uint totalAmount = getTotalAmountNeeded(_newsId);
        if ( balance <= totalAmount) {
            mint(contractOwner,incrementToken+totalAmount);
        }
        for(uint i=0;i< newsVoterMappings[_newsId].length;i++){
            transfer(newsVoterMappings[_newsId][i],rewardValue);
        }
    }

    function getTotalAmountNeeded(uint _newsId) public view returns (uint) {
        return newsVoterMappings[_newsId].length * rewardValue;
    }

    function downVote (uint _newsId) validVoter(_newsId,msg.sender) public {

        voters[msg.sender].push(_newsId);
        newsVoterMappings[_newsId].push(msg.sender);
        // update news vote Count
        newses[_newsId].voteCount ++;
        newses[_newsId].downVote ++;
        result(_newsId);
        // trigger voted event
        emit votedEvent(_newsId);
    }

    function result(uint _newsId ) public {
        if(newses[_newsId].upVote>newses[_newsId].downVote){
            newses[_newsId].verdict = "Real News";
        }
        else if(newses[_newsId].upVote<newses[_newsId].downVote){
            newses[_newsId].verdict = "Fake News";
        }
        else{
            newses[_newsId].verdict = "Tentative News";
        }
    }

    function getTokens() public view returns (uint) {
        return balanceOf(msg.sender);
    }

    
    function isOwnerContract() public view returns (bool) {
        if (msg.sender == contractOwner) {
            return true;
        }
        return false;
    }
    function getContractOwner() public view returns (address) {
        return contractOwner;
    }function caller() public view returns (address) {
        return msg.sender;
    }
  
}
