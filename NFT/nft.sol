pragma solidity 0.5.8;

import "./Ownable.sol";

// NFT 合约，可使用eth地址或者nch地址查询用户的NFT
contract NFT is Ownable {

    uint256 private maxTokenId;

    // 保存eth地址和nch地址之间的映射关系
    mapping (string => address) public addrs;

    // 保存NFT通证id和所有者地址之间的映射关系
    mapping (uint256 => address) private tokenOwners;

    // NFT通证id的存在关系
    mapping (uint256 => bool) private tokenExists;

    // NFT通证的总供应量
    uint256 public totalSupply;

    // 地址对应的通证余额
    mapping(address => uint) private balances;

    mapping (address => mapping (address => uint256)) allowed;

    // 记录每个用户持有的每个通证
    // 地址 - index - tokenId
    mapping (address => mapping (uint256 => uint256)) private ownerTokens;

    mapping (uint256 => string) tokenLinks;

    // 返回NFT通证的名称
    function name()  public pure returns (string memory) {
        return "BEE-EGG";
    }

    // 返回NFT通证的符号
    function symbol() public pure returns (string memory) {
        return "BEE-EGG";
    }

    /// 统计所持有的NFTs数量
    /// @param _ethAddress eth地址
    /// @return 返回数量，也许是0
    function balanceOfWithETHAddr(string memory _ethAddress) public view returns (uint256) {
        address owner = addrs[_ethAddress];
        return balances[owner];
    }

    /// 统计所持有的NFTs数量
    /// @param _owner nch地址
    /// @return 返回数量，也许是0
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    // 为指定eth地址分配一个NFT，并绑定nch地址
    // 只有管理员才可以调用此接口
    function mint(string memory _ethAddress, address _nchAddress) public onlyOwner {
        // 检查_ethAddress和_nchAddress的绑定关系
        address addr = addrs[_ethAddress];
        if (addr != address(0)) {
            require(addr == _nchAddress);
        }

        maxTokenId += 1;

        addrs[_ethAddress] = _nchAddress;
        tokenOwners[maxTokenId] = _nchAddress;
        tokenExists[maxTokenId] = true;
        balances[_nchAddress] += 1;
        totalSupply += 1;
    }

    // 计算属于某个owner的NFT通证id， 使用eth地址
    function tokenOfOwnerByIndexWithEthAddr(string memory _ethAddress, uint256 _index) public view returns (uint256) {
        address owner = addrs[_ethAddress];
        return ownerTokens[owner][_index];
    }

    // 计算属于某个owner的NFT通证id， 使用nch地址
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
        return ownerTokens[_owner][_index];
    }

    // 事件
    /// 当任何NFT的所有权更改时（不管哪种方式），就会触发此事件。
    ///  包括在创建时（`from` == 0）和销毁时(`to` == 0), 合约创建时除外。
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// 当更改或确认NFT的授权地址时触发。
    ///  零地址表示没有授权的地址。
    ///  发生 `Transfer` 事件时，同样表示该NFT的授权地址（如果有）被重置为“无”（零地址）。
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);



    /// 返回所有者
    /// @param _tokenId NFT 的id
    /// @return 返回所有者地址
    function ownerOf(uint256 _tokenId) public view returns (address) {
        require(tokenExists[_tokenId]);
        return tokenOwners[_tokenId];
    }

    function removeFromTokenList(address owner, uint256 _tokenId) private {
        for(uint256 i = 0; ownerTokens[owner][i] != _tokenId;i++){
            ownerTokens[owner][i] = 0;
        }
    }

    // NFT通证转移
    // _tokenId必须存在
    // 不能转给自己
    // 接收地址不能为0地址
    function transfer(address _to, uint256 _tokenId) public {
        address currentOwner = msg.sender;
        address newOwner = _to;

        require(tokenExists[_tokenId]);
        require(currentOwner == ownerOf(_tokenId));
        require(currentOwner != newOwner);
        require(newOwner != address(0));

        removeFromTokenList(currentOwner, _tokenId);
        balances[currentOwner] -= 1;
        tokenOwners[_tokenId] = newOwner;
        balances[newOwner] += 1;
        emit Transfer(currentOwner, newOwner, _tokenId);
    }

    /// 转移所有权 -- 调用者负责确认`_to`是否有能力接收NFTs，否则可能永久丢失。
    /// @dev 如果`msg.sender` 不是当前的所有者（或授权者、操作员）抛出异常
    /// 如果 `_from` 不是所有者、`_to` 是零地址、`_tokenId` 不是有效id 均抛出异常。
    /// 暂不支持`_to` 为合约地址，如果`_to` 为合约地址，则抛出异常
    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(tokenExists[_tokenId]);

        address oldOwner = ownerOf(_tokenId);
        address newOwner = _to;

        require(_from == oldOwner);
        require(newOwner != oldOwner);

        require(allowed[oldOwner][newOwner] == _tokenId);
        balances[oldOwner] -= 1;
        tokenOwners[_tokenId] = newOwner;
        balances[newOwner] += 1;

        emit Transfer(oldOwner, newOwner, _tokenId);
    }

    /// 更改NFT的授权地址
    /// 零地址表示没有授权的地址。
    ///  如果`msg.sender` 不是当前的所有者或操作员
    /// @param _to 新授权的控制者
    /// @param _tokenId ： token id
    function approve(address _to, uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId));
        require(msg.sender != _to);

        allowed[msg.sender][_to] = _tokenId;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(tokenExists[_tokenId]);

        address oldOwner = ownerOf(_tokenId);
        address newOwner = msg.sender;

        require(newOwner != oldOwner);

        require(allowed[oldOwner][newOwner] == _tokenId);
        balances[oldOwner] -= 1;
        tokenOwners[_tokenId] = newOwner;
        balances[newOwner] += 1;

        emit Transfer(oldOwner, newOwner, _tokenId);
    }

    /// 获取NFT通证对应的元数据，或者链接
    function tokenMetaData(uint256 _tokenId) public view returns (string memory infoUrl) {
        return tokenLinks[_tokenId];
    }

}