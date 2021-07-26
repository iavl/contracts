pragma solidity >=0.4.22 <0.6.0;


/*
竞拍者往竞拍主持人账户发起转账 Eth，如果竞拍不成功，则直接抛出异常，转账失败。
如果竞拍成功，则竞拍者资金暂时保存在 竞拍主持人账户里。
如果有新的更高的出价者，那么老的得主，可以从竞拍主持人账户里面 提取自己的保证金
投标结束后，拍卖主持人调用auctionEnd()函数，把拍卖成交价转账给 受益人
*/
contract SimpleAuction {
    // Parameters of the auction. Times are either
    address payable public beneficiary;

    // 拍卖持续的时间，now +auctionEndTime =拍卖截止时间
    uint public auctionEndTime;

    // Current state of the auction.
    address public highestBidder;
    uint public highestBid;

    //Allowed withdrawals of previous bids

    //给之前的最高出价者退钱，不是直接退，而是存在pendingRefunds里面，由竞拍的人主动取，只要你现在不是得主，就可以取钱了
    mapping(address => uint) pendingRefunds;

    // Set to true at the end, disallows any change.By default initialized to `false`.
    //投票结束 收款的时候会触发一次收款，然后 ended设置为true
    bool ended;

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // The following is a so-called natspec comment,
    // recognizable by the three slashes.
    // It will be shown when the user is asked to
    // confirm a transaction.

    /// Create a simple auction with `_bidDuration`
    /// seconds bidding time on behalf of the
    /// beneficiary address `_beneficiary`.
    constructor(uint _bidDuration,address payable _beneficiary) public {
        beneficiary = _beneficiary;
        auctionEndTime = now + _bidDuration;
    }

    /// Bid on the auction with the value sent together with this transaction.(竞拍价就是 该笔交易的转账金额)
    /// The value will only be refunded if the auction is not won.
    function bid() public payable {
        // No arguments are necessary, all information is already part of the transaction.
        //The keyword payable is required for the function to be able to receive Ether.
        // Revert the call if the bidding period is over.
        require(
            now <= auctionEndTime,
            "Auction already ended."
        );

        // If the bid is not higher, send the money back.
        //msg.value (uint): 和消息一起发送的wei的数量
        require(
            msg.value > highestBid,
            "There already is a higher bid."
        );

        //给之前的最高出价者退钱，不是直接退，而是存在pendingReturns里面，由 竞拍的人主动取
        if (highestBid != 0) {
            // Sending back the money by simply using highestBidder.send(highestBid) is a security risk
            // because it could execute an untrusted contract.
            // It is always safer to let the recipients withdraw their money themselves.
            pendingRefunds[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        //通知最新的得主
        emit HighestBidIncreased(msg.sender, msg.value);
    }



    //流标的竞标者可以随时取回自己的保证金
    function withdraw() public returns (bool) {
        uint amount = pendingRefunds[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingRefunds[msg.sender] = 0;
            //发起退款，如果退款失败，就重置可退款信息
            if (!msg.sender.send(amount)) {
                // No need to call throw here, just reset the amount owing
                pendingRefunds[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// End the auction and send the highest bid to the beneficiary.
    //这个交易必须由拍卖主持人调用，因为会触发扣款啊。竞拍人往 竞拍主持人账户转账 发起竞拍，最终竞拍结束，竞拍主持人把 最终竞拍成交价 转账给 收款人
    function auctionEnd() public {
        // 1. Conditions
        require(now >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        beneficiary.transfer(highestBid);
    }
}