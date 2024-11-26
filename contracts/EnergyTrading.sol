// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EnergyTrading is ERC20 {

    struct EnergyListing {
        address provider;        // Address of energy provider
        uint256 energyAmount;    // Energy amount in kWh
        uint256 basePricePerKWh; // Base price per kWh in Energy Tokens
        uint256 dynamicPricePerKWh; // Dynamic price per kWh based on supply-demand
        bool isAvailable;        // Is the listing available for trade
    }

    uint256 public totalSupplyEnergy; 
    uint256 public totalDemand;       
    mapping(uint256 => EnergyListing) public energyListings;
    uint256 public listingCounter;

    event EnergyListed(uint256 indexed listingId, address indexed provider, uint256 energyAmount, uint256 pricePerKWh);
    event EnergyPurchased(uint256 indexed listingId, address indexed buyer, uint256 energyAmount);
    event EnergyDeliveryConfirmed(uint256 indexed listingId, address indexed provider, address indexed buyer);
    event PriceAdjusted(uint256 indexed listingId, uint256 newPrice);

    constructor() ERC20("EnergyToken", "ETK") {}

    function mintTokens(address to, uint256 amount) public {
        _mint(to, amount);
    }
    function listEnergy(uint256 _energyAmount, uint256 _basePricePerKWh) public {
        require(_energyAmount > 0, "Energy amount must be greater than 0");
        require(_basePricePerKWh > 0, "Price per kWh must be greater than 0");

        listingCounter++;
        uint256 initialDynamicPrice = _basePricePerKWh; 

        energyListings[listingCounter] = EnergyListing({
            provider: msg.sender,
            energyAmount: _energyAmount,
            basePricePerKWh: _basePricePerKWh,
            dynamicPricePerKWh: initialDynamicPrice,
            isAvailable: true
        });

        totalSupplyEnergy += _energyAmount; 
        adjustDynamicPriceForAllListings();
        emit EnergyListed(listingCounter, msg.sender, _energyAmount, initialDynamicPrice);
    }

    function adjustDynamicPriceForAllListings() internal {
        for (uint256 i = 1; i <= listingCounter; i++) {
            if (energyListings[i].isAvailable) {
                adjustDynamicPrice(i);
            }
        }
    }

    function adjustDynamicPrice(uint256 _listingId) internal {
        EnergyListing storage listing = energyListings[_listingId];
        uint256 basePrice = listing.basePricePerKWh;

        // Calculate dynamic price based on current supply and demand
        if (totalSupplyEnergy > totalDemand) {
            // More supply than demand, price decreases
            listing.dynamicPricePerKWh = basePrice - (basePrice * (totalSupplyEnergy - totalDemand) / totalSupplyEnergy) / 10;
        } else {
            // More demand than supply, price increases
            listing.dynamicPricePerKWh = basePrice + (basePrice * (totalDemand - totalSupplyEnergy) / totalDemand) / 10;
        }

        emit PriceAdjusted(_listingId, listing.dynamicPricePerKWh);
    }

    function purchaseEnergy(uint256 _listingId, uint256 _energyAmount) public {
        EnergyListing storage listing = energyListings[_listingId];
        require(listing.isAvailable, "Energy is no longer available");
        require(_energyAmount <= listing.energyAmount, "Not enough energy available");

        uint256 totalCost = (_energyAmount * listing.dynamicPricePerKWh) / 1 ether;
        require(balanceOf(msg.sender) >= totalCost, "Insufficient Energy Tokens");

        _transfer(msg.sender, listing.provider, totalCost);

        listing.energyAmount -= _energyAmount;
        if (listing.energyAmount == 0) {
            listing.isAvailable = false; // Mark listing as sold out
        }

        totalDemand += _energyAmount;  // Increase demand count
        totalSupplyEnergy -= _energyAmount;  // Decrease total supply
        adjustDynamicPriceForAllListings();

        emit EnergyPurchased(_listingId, msg.sender, _energyAmount);
    }

    function updateEnergyListing(uint256 _listingId, uint256 _newEnergyAmount) public {
        EnergyListing storage listing = energyListings[_listingId];
        require(listing.provider == msg.sender, "Only provider can update this listing");
        require(_newEnergyAmount >= 0, "Energy amount cannot be negative");

        totalSupplyEnergy -= listing.energyAmount; // Adjust total supply before update
        listing.energyAmount = _newEnergyAmount;
        totalSupplyEnergy += _newEnergyAmount; // Update total supply
    
        if (_newEnergyAmount == 0) {
            listing.isAvailable = false; // Mark as unavailable if no energy left
        }

        adjustDynamicPriceForAllListings();
    }

    function confirmEnergyDelivery(uint256 _listingId) public {
        EnergyListing storage listing = energyListings[_listingId];
        require(listing.provider == msg.sender, "Only provider can confirm delivery");

        adjustDynamicPriceForAllListings();
        emit EnergyDeliveryConfirmed(_listingId, listing.provider, msg.sender);
    }

    function getBalance(address _user) public view returns (uint256) {
        return balanceOf(_user);
    }

    function getListingDetails(uint256 _listingId) public view returns (address, uint256, uint256, uint256, bool) {
        EnergyListing memory listing = energyListings[_listingId];
        return (listing.provider, listing.energyAmount, listing.basePricePerKWh, listing.dynamicPricePerKWh, listing.isAvailable);
    }
}
