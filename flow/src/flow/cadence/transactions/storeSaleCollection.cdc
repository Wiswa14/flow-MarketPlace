import MetaVEvents from "../contracts/MetaVEvents.cdc"
import NonFungibleToken from "../utility/NonFungibleToken.cdc"
import NftMarketPlace from "../contracts/NftMarketPlace.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import FungibleToken from "../utility/FungibleToken.cdc"

transaction(){
 prepare(acct: AuthAccount){
    let MyNftCollection =  acct.getCapability<&MetaVEvents.Collection>(MetaVEvents.CollectionPublicPath)
    let flowTokenVault = acct.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
    acct.save(<-NftMarketPlace.createSaleCollection(MyNftCollection:MyNftCollection,flowTokenVault:flowTokenVault),to:/storage/MySaleCollection)
    acct.link<&NftMarketPlace.saleCollection{NftMarketPlace.saleCollectionPublic}>(/public/MySaleCollection,target:/storage/MySaleCollection)

    }

    execute{
        log("A user stored a nft collection inside his account")
    }

  }