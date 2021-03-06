# NFT接口文档

## 介绍

基于智能合约实现，依托于NetCloth链的EVM运行。具有以下特性：

1. 在合约范围内，每个NFT通证具有唯一的tokenId
2. tokenId只能被一个owner地址所拥有，支持eth地址和nch地址
3. 一个owner可以拥有多个NFT通证，其balance只记录数量。有额外的存储列表记录tokenId和owner地址的对应关系
4. 提供approve, transfer接口方法，用于通证流通
5. 支持NFT通证元数据，可以是元数据或者链接
6. 提供beeMint接口方法，用于NFT通证的生成和发行，由管理员账户控制，管理员账户在创建合约时指定

## 接口详细描述

### name
    
    
```
function name()  public pure returns (string memory) 
```
    
功能描述：获取NFT通证的名称
    
    
Returns:
    
string | NFT通证的名称
---|---


### symbol
    
    
```
function symbol() public pure returns (string memory)
```
    
功能描述：获取NFT通证的符号
    
参数描述：无
    
Returns:
    
string | NFT通证的符号
---|---

### totalSupply
    
    
```
function totalSupply() public view returns (uint256)
```
    
功能描述：获取NFT通证的总量
   
参数描述：无 
    
Returns:
    
string | NFT通证的总量
---|---


### balanceOf
    
    
```
function balanceOf(address _owner) public view returns (uint256) 
```
    
功能描述：统计_owner地址所持有的NFT数量

参数描述：

参数 | 类型  |  描述
---|---|---
_owner| address | nch账号地址
 
    
Returns:
    
uint256 | NFT数量
---|---

### balanceOfWithETHAddr
    
    
```
function balanceOfWithETHAddr(string memory _ethAddress) public view returns (uint256) 
```
    
功能描述：统计指定eth地址所持有的NFT数量
    
参数描述：

参数 | 类型  |  描述
---|---|---
_ethAddress | string | eth钱包地址


Returns:
    
uint256 | _ethAddress所持有的NFT数量
---|---



### beeMint
    
    
```
function beeMint(string memory _ethAddress, address _to, uint256 _tokenId) public onlyOwner
```
    
功能描述：为指定地址产生一个NFT通证
    
参数描述：

参数 | 类型  |  描述
---|---|---
_ethAddress | string | eth钱包地址
_to | address | nch钱包地址
_tokenId | uint256 | NFT通证id

Returns:
无


### tokenByIndex
    
    
```
function tokenByIndex(uint256 _index) public view returns (uint256)
```
    
功能描述：根据index获取某个NFT通证的id
    
参数描述：

参数 | 类型  |  描述
---|---|---
_index | uint256 | 索引值


Returns:

uint256 | NFT通证id
---|---

### tokenOfOwnerByIndex
    
    
```
function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256)
```
    
功能描述：获取某个owner指定index的NFT通证的id

参数描述：

参数 | 类型  |  描述
---|---|---
_owner | address | nch账号地址
_index | uint256 | 索引值

    
Returns:

uint256 | NFT通证id
---|---


### tokenOfOwnerByIndexWithEthAddr
    
    
```
function tokenOfOwnerByIndexWithEthAddr(string memory _ethAddress, uint256 _index) public view returns (uint256) 

```
    
功能描述：获取某个eth地址的指定index的NFT通证的id

参数描述：

参数 | 类型  |  描述
---|---|---
_ethAddress | string | eth账号地址
_index | uint256 | 索引值

Returns:

uint256 | NFT通证id
---|---



### ownerOf
    
    
```
function ownerOf(uint256 _tokenId) public view returns (address)

```
    
功能描述：查询指定NFT通证id的所属owner

参数描述：

参数 | 类型  |  描述
---|---|---
_tokenId | uint256 | NFT通证id

Returns:

address | owner地址
---|---



### safeTransferFrom
    
    
```
function safeTransferFrom(address _from, address _to, uint256 _tokenId) public

```
    
功能描述：转移指定NFT id的通证

参数描述：

参数 | 类型  |  描述
---|---|---
_from | address | 发送NFT通证的地址
_to | address | 接收NFT通证的地址
_tokenId | uint256 | NFT通证的id
    
Returns:

无


### approve
    
    
```
 function approve(address _to, uint256 _tokenId) public
```
    
功能描述：更改NFT的授权地址
    
参数描述：

参数 | 类型  |  描述
---|---|---
_to | address | 被授权的NFT通证的地址
_tokenId | uint256 | NFT通证的id
   
Returns:

无
