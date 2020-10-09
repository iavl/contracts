pragma solidity 0.5.8;

import "./INRC721.sol";
import "../utils/Ownable.sol";
import "../utils/EnumerableSet.sol";
import "../utils/EnumerableMap.sol";
import "../utils/Address.sol";
import "../math/SafeMath.sol";

contract NFT is INRC721, Ownable {
    using SafeMath for uint256;
    using Address for address;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    // Mapping from eth address to nch address
    mapping (string => address) public addrs;

    // Mapping from holder address to their (enumerable) set of owned tokens
    mapping (address => EnumerableSet.UintSet) private holderTokens;

    // Enumerable mapping from token ids to their owners
    EnumerableMap.UintToAddressMap private tokenOwners;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private tokenApprovals;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private operatorApprovals;

    // Optional mapping for token URIs
    mapping(uint256 => string) private tokenURIs;

    // Base URI
    string public baseURI;

    /**
      * @dev Gets the token name.
      * @return string representing the token name
     */
    function name()  public pure returns (string memory) {
        return "BEE-EGG";
    }

    /**
     * @dev Gets the token symbol.
     * @return string representing the token symbol
     */
    function symbol() public pure returns (string memory) {
        return "BEE-EGG";
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "NRC721: balance query for the zero address");
        return holderTokens[_owner].length();
    }

    function balanceOfWithETHAddr(string memory _ethAddress) public view returns (uint256) {
        address owner = addrs[_ethAddress];
        return balanceOf(owner);
    }

    /**
     * @dev Gets the owner of the specified token ID.
     * @param _tokenId uint256 ID of the token to query the owner of
     * @return address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 _tokenId) public view returns (address) {
        return tokenOwners.get(_tokenId, "NRC721: owner query for nonexistent token");
    }

    /**
     * @dev Returns the URI for a given token ID. May return an empty string.
     *
     * If the token's URI is non-empty and a base URI was set (via
     * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
     *
     * Reverts if the token ID does not exist.
     */
    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        require(_exists(_tokenId), "NRC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = tokenURIs[_tokenId];

        // Even if there is a base URI, it is only appended to non-empty token-specific URIs
        if (bytes(_tokenURI).length == 0) {
            return "";
        } else {
            // abi.encodePacked is being used to concatenate strings
            return string(abi.encodePacked(baseURI, _tokenURI));
        }
    }


    /**
     * @dev Gets the token ID at a given index of the tokens list of the requested owner.
     * @param _owner address owning the tokens list to be accessed
     * @param _index uint256 representing the index to be accessed of the requested tokens list
     * @return uint256 token ID at the given index of the tokens list owned by the requested address
     */
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
        return holderTokens[_owner].at(_index);
    }

    function tokenOfOwnerByIndexWithEthAddr(string memory _ethAddress, uint256 _index) public view returns (uint256)  {
        address owner = addrs[_ethAddress];
        return holderTokens[owner].at(_index);
    }

    /**
    * @dev Gets the total amount of tokens stored by the contract.
    * @return uint256 representing the total amount of tokens
    */
    function totalSupply() public view returns (uint256) {
        // tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
        return tokenOwners.length();
    }

    /**
     * @dev Gets the token ID at a given index of all the tokens in this contract
     * Reverts if the index is greater or equal to the total number of tokens.
     * @param _index uint256 representing the index to be accessed of the tokens list
     * @return uint256 token ID at the given index of the tokens list
     */
    function tokenByIndex(uint256 _index) public view returns (uint256) {
        (uint256 tokenId, ) = tokenOwners.at(_index);
        return tokenId;
    }

    /**
     * @dev Approves another address to transfer the given token ID
     * The zero address indicates there is no approved address.
     * There can only be one approved address per token at a given time.
     * Can only be called by the token owner or an approved operator.
     * @param _to address to be approved for the given token ID
     * @param _tokenId uint256 ID of the token to be approved
     */
    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner, "NRC721: approval to current owner");

        require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "NRC721: approve caller is not owner nor approved for all"
        );

        _approve(_to, _tokenId);
    }

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * Reverts if the token ID does not exist.
     * @param _tokenId uint256 ID of the token to query the approval of
     * @return address currently approved for the given token ID
     */
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(_exists(_tokenId), "NRC721: approved query for nonexistent token");

        return tokenApprovals[_tokenId];
    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf.
     * @param _operator operator address to set the approval
     * @param _approved representing the status of the approval to be set
     */
    function setApprovalForAll(address _operator, bool _approved) public {
        require(_operator != msg.sender, "NRC721: approve to caller");

        operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /**
     * @dev Tells whether an operator is approved by a given owner.
     * @param _owner owner address which you want to query the approval of
     * @param _operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return operatorApprovals[_owner][_operator];
    }

    /**
    * @dev beeMint
    * call _safeMint to generate new NFT token
    * @param _to The address that will own the minted token
    * @param _tokenId uint256 ID of the token to be minted
    */
    function beeMint(string memory _ethAddress, address _to, uint256 _tokenId) public onlyOwner  {
        // 检查_ethAddress和_nchAddress的绑定关系
        address addr = addrs[_ethAddress];
        if (addr != address(0)) {
            require(addr == _to);
        }

        _safeMint(_to, _tokenId, "");
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * Requires the msg.sender to be the owner, approved, or operator
     * @param _from current owner of the token
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
     */
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public  {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "NRC721: transfer caller is not owner nor approved");
        _safeTransfer(_from, _to, _tokenId, _data);
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * Requires the msg.sender to be the owner, approved, or operator
     * @param _from current owner of the token
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
     * @param _data bytes data to send along with a safe transfer check
     */
    function _safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) internal {
        _transfer(_from, _to, _tokenId);
        require(_checkOnNRC721Received(_from, _to, _tokenId, _data), "NRC721: transfer to non NRC721Receiver implementer");
    }

    /**
     * @dev Returns whether the given spender can transfer a given token ID.
     * @param _spender address of the spender to query
     * @param _tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     * is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
        require(_exists(_tokenId), "NRC721: operator query for nonexistent token");
        address owner = ownerOf(_tokenId);
        return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
    }

    /**
    * @dev Internal function to safely mint a new token.
    * Reverts if the given token ID already exists.
    * @param _to The address that will own the minted token
    * @param _tokenId uint256 ID of the token to be minted
    */
    function _safeMint(address _to, uint256 _tokenId) internal {
        _safeMint(_to, _tokenId, "");
    }

    /**
     * @dev Internal function to safely mint a new token.
     * Reverts if the given token ID already exists.
     * @param _to The address that will own the minted token
     * @param _tokenId uint256 ID of the token to be minted
     * @param _data bytes data to send along with a safe transfer check
     */
    function _safeMint(address _to, uint256 _tokenId, bytes memory _data) internal {
        _mint(_to, _tokenId);
        require(_checkOnNRC721Received(address(0), _to, _tokenId, _data), "NRC721: transfer to non NRC721Receiver implementer");
    }

    /**
     * @dev Internal function to mint a new token.
     * Reverts if the given token ID already exists.
     * @param _to The address that will own the minted token
     * @param _tokenId uint256 ID of the token to be minted
     */
    function _mint(address _to, uint256 _tokenId) internal {
        require(_to != address(0), "NRC721: mint to the zero address");
        require(!_exists(_tokenId), "NRC721: token already minted");

        _beforeTokenTransfer(address(0), _to, _tokenId);

        holderTokens[_to].add(_tokenId);

        tokenOwners.set(_tokenId, _to);

        emit Transfer(address(0), _to, _tokenId);
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     * @param _from current owner of the token
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
     */
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from, "ERC721: transfer of token that is not own");
        require(_to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(_from, _to, _tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), _tokenId);

        holderTokens[_from].remove(_tokenId);
        holderTokens[_to].add(_tokenId);

        tokenOwners.set(_tokenId, _to);

        emit Transfer(_from, _to, _tokenId);
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 _tokenId) internal view returns (bool) {
        return tokenOwners.contains(_tokenId);
    }

    /**
     * @dev Internal function to set the token URI for a given token.
     * Reverts if the token ID does not exist.
     */
    function _setTokenURI(uint256 _tokenId, string memory _tokenURI) internal {
        require(_exists(_tokenId), "NRC721Metadata: URI set of nonexistent token");
        tokenURIs[_tokenId] = _tokenURI;
    }

    /**
     * @dev Internal function to set the base URI for all token IDs. It is
     * automatically added as a prefix to the value returned in {tokenURI}.
     */
    function _setBaseURI(string memory _baseURI) internal {
        baseURI = _baseURI;
    }

    /**
     * @dev Internal function to invoke {INRC721Receiver-onNRC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param _from address representing the previous owner of the given token ID
     * @param _to target address that will receive the tokens
     * @param _tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnNRC721Received(address _from, address _to, uint256 _tokenId, bytes memory _data)
    private returns (bool)
    {
        if (!_to.isContract()) {
            return true;
        }
    }

    function _approve(address _to, uint256 _tokenId) private {
        tokenApprovals[_tokenId] = _to;
        emit Approval(ownerOf(_tokenId), _to, _tokenId);
    }

    function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal { }


}