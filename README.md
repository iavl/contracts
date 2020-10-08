# 接口

## 合约接口详细描述

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
    
    
Returns:
    
string | NFT通证的符号
---|---


### balanceOf
    
    
```
function balanceOf(address _owner) public view returns (uint256) 
```
    
功能描述：统计所持有的NFT数量
    
    
Returns:
    
uint256 | _owner所持有的NFT数量
---|---

### balanceOfWithETHAddr
    
    
```
function balanceOfWithETHAddr(string memory _ethAddress) public view returns (uint256) 
```
    
功能描述：统计指定eth地址所持有的NFT数量
    
    
Returns:
    
uint256 | _ethAddress所持有的NFT数量
---|---



### mint
    
    
```
function mint(string memory _ethAddress, address _nchAddress) public onlyOwner
```
    
功能描述：为指定地址产生一个NFT通证
    
    
Returns:
无

### tokenOfOwnerByIndex
    
    
```
function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256)
```
    
功能描述：获取某个owner指定index的NFT通证的id
    
    
Returns:

uint256 | NFT通证id
---|---


### tokenOfOwnerByIndexWithEthAddr
    
    
```
function tokenOfOwnerByIndexWithEthAddr(string memory _ethAddress, uint256 _index) public view returns (uint256) 

```
    
功能描述：获取某个eth地址的指定index的NFT通证的id
    
    
Returns:

uint256 | NFT通证id
---|---



### ownerOf
    
    
```
function ownerOf(uint256 _tokenId) public view returns (address)

```
    
功能描述：查询指定NFT通证id的所属owner
    
    
Returns:

address | owner地址
---|---



### transfer
    
    
```
function transfer(address _to, uint256 _tokenId) public

```
    
功能描述：转移指定NFT id的通证
    
    
Returns:

无



### transferFrom
    
    
```
 function transferFrom(address _from, address _to, uint256 _tokenId) public 
```
    
功能描述：从指定账户转移指定NFT id的通证
    
    
Returns:

无

### approve
    
    
```
 function approve(address _to, uint256 _tokenId) public
```
    
功能描述：更改NFT的授权地址
    
    
Returns:

无

### tokenMetaData
    
    
```
function tokenMetaData(uint256 _tokenId) public view returns (string memory infoUrl)
```
    
功能描述：获取NFT通证对应的元数据，或者链接
    
    
Returns:

string | 元数据或链接
---|---

