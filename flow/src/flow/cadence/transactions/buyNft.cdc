import MetaVEvents from "../contracts/MetaVEvents.cdc"
import NonFungibleToken from "../utility/NonFungibleToken.cdc"
import NftMarketPlace from "../contracts/NftMarketPlace.cdc"
import FlowToken from "../contracts/FlowToken.cdc"


transaction(account: Address, id: UInt64) {
  prepare(acct: AuthAccount) {

    let saleCollection = getAccount(account).getCapability(/public/MySaleCollection)
                                           .borrow<&NftMarketPlace.saleCollection{NftMarketPlace.saleCollectionPublic}>()

    let recipientCollection = getAccount(acct.address).getCapability(MetaVEvents.CollectionPublicPath)
                    .borrow<&MetaVEvents.Collection{NonFungibleToken.CollectionPublic}>()
                    ?? panic("Can't get the User's collection.")
    let price = saleCollection.getPrice(id: id)
    let payment <- acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!.withdraw(amount: price) as! @FlowToken.Vault
    saleCollection.purchase(id: id, receipientCollection: recipientCollection, payment: <- payment)
  }
  execute {
    log("A user purchased an NFT")
  }
}
