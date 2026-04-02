// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721{
    uint256 private s_tokenCounter;
    string private s_sadsvg;
    string private s_happysvg;
    enum Mood{
        HAPPY,
        SAD
    }
    mapping(uint256=>Mood) private s_tokenIdToMood;
   

    constructor(string memory sadsvguri,string memory happysvguri) ERC721("Mood NFT","MN") {
        s_tokenCounter=0;
        s_sadsvg=sadsvguri;
        s_happysvg=happysvguri;
    }
    function mintNft() public{
        s_tokenIdToMood[s_tokenCounter]=Mood.HAPPY;
        _safeMint(msg.sender,s_tokenCounter);
        s_tokenCounter++;

    }
     function flipMood(uint256 tokenId) public {
        if(_ownerOf(tokenId) != msg.sender){
            revert("Not the owner of the token");
        }
        if(s_tokenIdToMood[tokenId]==Mood.HAPPY){
            s_tokenIdToMood[tokenId]=Mood.SAD;
        }
        else{
            s_tokenIdToMood[tokenId]=Mood.HAPPY;   
        }
    }
   function tokenURI(uint256 tokenId) public view override returns(string memory){
    Mood mood=s_tokenIdToMood[tokenId];
    string memory svguri=mood==Mood.HAPPY?s_happysvg:s_sadsvg;
    string memory tokenmetadata=string(abi.encodePacked('{"name":"',name(),'","description":"A mood nft that changes based on the mood of the owner","attributes":[{"trait_type":"mood","value":"',mood==Mood.HAPPY?"happy":"sad",'"}],"image":"',svguri,'"}'));
    return string(abi.encodePacked("data:application/json;base64,",Base64.encode(bytes(tokenmetadata))));
   }

}