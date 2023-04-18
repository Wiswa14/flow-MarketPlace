import MetaVEvents from "../contracts/MetaVEvents.cdc"
import NonFungibleToken from "../utility/NonFungibleToken.cdc"

transaction(){
 prepare(acct: AuthAccount){
        acct.save(<-MetaVEvents.createEmptyCollection(),to:MetaVEvents.CollectionStoragePath)
        acct.link<&MetaVEvents.Collection{MetaVEvents.CollectionPublic,NonFungibleToken.CollectionPublic}>(/public/MetaVEventsNftCollections, target:MetaVEvents.CollectionStoragePath)
    }

    execute{
        log("Successfully created a collection inside the user account")
    }

  }