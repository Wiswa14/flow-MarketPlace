import FlowToken from "./FlowToken.cdc"
 import MetaVEvents from "./MetaVEvents.cdc"
import NonFungibleToken from "../utility/NonFungibleToken.cdc"
import FungibleToken from "../utility/FungibleToken.cdc"
// import MetaVEvents from "../contracts/MetaVEvents.cdc"

pub contract NftMarketPlace{

pub resource interface saleCollectionPublic{
pub fun getIDs(): [UInt64]
pub fun getPrice(id:UInt64):UFix64
pub fun purchase(id:UInt64,receipientCollection:&MetaVEvents.Collection{NonFungibleToken.CollectionPublic},payment:@FlowToken.Vault)

}



pub resource saleCollection:saleCollectionPublic {
// mapping the nftId to the price of the NFTId
pub var forSale:{UInt64:UFix64}
pub let MyNftCollection: Capability<&MetaVEvents.Collection>
pub let FlowTokenVault: Capability<&FlowToken.Vault{FungibleToken.Receiver}>

pub fun assetListing(id:UInt64,price:UFix64){
     pre{
          price >0.0:"It doesn't make sense to list a token for less than 0.0"
          self.MyNftCollection.borrow()!.getIDs().contains(id):"This nft is not present in the collection"
     }
  self.forSale[id]= price
}

pub fun assetUnlisting(id:UInt64){
     self.forSale.remove(key:id)
}

pub fun purchase(id:UInt64,receipientCollection:&MetaVEvents.Collection{NonFungibleToken.CollectionPublic},payment:@FlowToken.Vault){

     pre{
          payment.balance == self.forSale[id]:"   The payment is not equal to the price of the nft"

     }

     receipientCollection.deposit(token: <-self.MyNftCollection.borrow()!.withdraw(withdrawID:id) )
     self.FlowTokenVault.borrow()!.deposit(from: <- payment)



}

pub fun getPrice(id:UInt64):UFix64{
     return self.forSale[id]!
}

pub fun getIDs():[UInt64]{
     return self.forSale.keys
}


init(_MyNftCollection: Capability<&MetaVEvents.Collection>,_flowTokenVault:Capability<&FlowToken.Vault{FungibleToken.Receiver}>){
     self.forSale ={}
     self.MyNftCollection = _MyNftCollection
     self.FlowTokenVault = _flowTokenVault

}


}

pub fun createSaleCollection(MyNftCollection: Capability<&MetaVEvents.Collection>,flowTokenVault:Capability<&FlowToken.Vault{FungibleToken.Receiver}>):@saleCollection{
     return <- create saleCollection(_MyNftCollection:MyNftCollection,_flowTokenVault:flowTokenVault)


}
init(){

}
}
