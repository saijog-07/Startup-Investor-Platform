// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StartupInvestorPlatform {
    struct Startup {
        address payable founder; // Marked as payable to receive funds
        string name;
        string description;
        uint fundingGoal;
        uint fundsRaised;
    }

    struct Investor {
        address investorAddress;
        uint amountInvested;
    }

    mapping(address => Startup) public startups;
    mapping(address => Investor[]) public investments;

    event StartupCreated(address indexed founder, string name, uint fundingGoal);
    event InvestmentMade(address indexed investor, address indexed startup, uint amount);

    // Create a new startup
    function createStartup(string memory _name, string memory _description, uint _fundingGoal) public {
        require(bytes(_name).length > 0, "Startup name is required");
        require(_fundingGoal > 0, "Funding goal must be greater than zero");

        startups[msg.sender] = Startup(payable(msg.sender), _name, _description, _fundingGoal, 0);
        
        emit StartupCreated(msg.sender, _name, _fundingGoal);
    }

    // Get details of a startup
    function getStartupDetails(address _founder) public view returns (
        string memory, string memory, uint, uint
    ) {
        Startup memory startup = startups[_founder];
        return (startup.name, startup.description, startup.fundingGoal, startup.fundsRaised);
    }

    // Investing in a startup
    function invest(address _startup) public payable {
        require(msg.value > 0, "Investment must be greater than zero");
        require(bytes(startups[_startup].name).length > 0, "Startup does not exist");

        // Update the funds raised
        startups[_startup].fundsRaised += msg.value;

        // Record the investment
        investments[_startup].push(Investor(msg.sender, msg.value));

        // Transfer the funds to the startup founder
        startups[_startup].founder.transfer(msg.value);

        emit InvestmentMade(msg.sender, _startup, msg.value);
    }

    // Get total investments for a startup
    function getTotalInvestments(address _startup) public view returns (uint) {
        return startups[_startup].fundsRaised;
    }
}
