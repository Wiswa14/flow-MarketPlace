import MetaVEvents from "../contracts/MetaVEvents.cdc"
import NonFungibleToken from "../utility/NonFungibleToken.cdc"
import NftMarketPlace from "../contracts/NftMarketPlace.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import FungibleToken from "../utility/FungibleToken.cdc"

transaction(id:UInt64,price:UFix64){
 prepare(acct: AuthAccount){
    let SaleCollection = acct.borrow<&NftMarketPlace.saleCollection>(from: /storage/MySaleCollection)
                          ??panic("This saleCollection does not exist")
    SaleCollection.assetListing(id:id,price:price)

    }

    execute{
        log("A user listed an nft for sale")
    }

}