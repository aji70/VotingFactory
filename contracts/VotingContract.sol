// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Elections {

    address owner = msg.sender;

    struct Candidate{
        uint id;
        string name;
        string party;
        uint voteCount;
    }
    
   
   Candidate [] public candidate;
   uint candidateCount;
    


    mapping (address => bool) registerd;
    mapping (address => bool) hasVoted;
    address[]  registeredVoters;
   
    uint  votingTimeLeft;

    uint totalCastedVotes;


    modifier verifiedVoter(){
        require(!hasVoted[msg.sender], "You have voted");
        require(registerd[msg.sender] == true, 'Not a registered Voter');
        require(votingTimeLeft > 0, 'voting time have elapsed');
        _;
    }

    function createCandidate(string memory _name, string memory _party) public {
        uint id = candidateCount + 1;
        Candidate memory newCandidate = Candidate(id, _name, _party, 0 );
        candidate.push(newCandidate);
        candidateCount++;

    }

    


    function register() public {
      address _voter = msg.sender;
        require(!registerd[_voter] , 'You have registered');
        hasVoted[msg.sender] = false;
        registerd[_voter] = true;
        registeredVoters.push(_voter);
      
        votingTimeLeft =  block.timestamp + 600 ;
        
    }

    function vote(uint _id) public verifiedVoter  returns(uint){
        Candidate storage Votingcandidate = candidate[_id];

        Votingcandidate.voteCount ++ ;
        hasVoted[msg.sender] = true;
        totalCastedVotes++;

        return Votingcandidate.voteCount ;


    }
  
    function getWinner() public view returns (string memory) {
    uint highestVotes = 0;
    string memory winnerName;
    
    for (uint i = 0; i < candidate.length; i++) {
        if (candidate[i].voteCount > highestVotes) {
            highestVotes = candidate[i].voteCount;
            winnerName = candidate[i].name;
        } else if (candidate[i].voteCount == highestVotes) {
            winnerName = "Inconclusive"; // Handle tie
        }
    }
    
    return winnerName;
}

    function totalCastedvotes() public view returns(uint){
        return totalCastedVotes;
    }



    function totalRegisteredVoters() public view returns (uint){
        return registeredVoters.length;
    }



    function votingTime() public view returns(uint){
      return votingTimeLeft - block.timestamp ;
    }
    
    
}
contract ElectionsFactory {
    Elections[] public electionContracts;

    function createElection() public {
        Elections newElection = new Elections();
        electionContracts.push(newElection);
    }

    function getElectionCount() public view returns (uint) {
        return electionContracts.length;
    }

    function getElection(uint _index) public view returns (Elections) {
        require(_index < electionContracts.length, "Index out of bounds");
        return electionContracts[_index];
    }
}