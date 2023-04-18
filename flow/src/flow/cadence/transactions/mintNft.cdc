import MetaVEvents from "../contracts/MetaVEvents.cdc"

transaction(id:UInt64,maxCount:UInt64,metadata:{String:String}){

prepare(acct: AuthAccount){
 let collection = acct.borrow<&MetaVEvents.Collection>(from: MetaVEvents.CollectionStoragePath)
                   ?? panic("This account doesn't have any collections")

 let nft <- MetaVEvents.mint(id: id, maxCount: maxCount, metadata: metadata)
 collection.deposit(token: <-nft)

}

execute{
 log("A user minted an NFT into their account")
}
}