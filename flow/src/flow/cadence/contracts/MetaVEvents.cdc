import NonFungibleToken from "../utility/NonFungibleToken.cdc"

   pub contract MetaVEvents:NonFungibleToken{
       pub let creator:Address
       pub let nxmAddress:Address
       pub let projId:UInt64
        pub var totalSupply: UInt64

        pub let ticketCount:{UInt64:UInt64}

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath



       init(){
        self.creator = 0xee82856bf20e2aa6
        self.nxmAddress = 0xee82856bf20e2aa6
        self.projId = 1
         // Initialize the total supply
        self.totalSupply = 0

        self.ticketCount ={}

         // Set the named paths
        self.CollectionStoragePath = /storage/MetaVEventsNftCollections
        self.CollectionPublicPath = /public/MetaVEventsNftCollections

        emit ContractInitialized()
       }

       pub resource NFT:NonFungibleToken.INFT{
        pub let id:UInt64
        pub let maxCount:UInt64
        pub let metadata:{String:String}

        init(_nftId:UInt64,_maxCount:UInt64,_metadata:{String : String}){
          self.id = _nftId
          self.maxCount =_maxCount
          self.metadata =_metadata

        }
       }

         pub resource interface CollectionPublic {
    pub fun borrowEntireNFT(id: UInt64): &MetaVEvents.NFT
  }

      pub resource Collection:NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic,CollectionPublic{
        pub var ownedNFTs: @{UInt64:NonFungibleToken.NFT}

        pub fun deposit(token:@NonFungibleToken.NFT){
          let myToken <- token as! @MetaVEvents.NFT
          emit Deposit(id:myToken.id,to:self.owner?.address)
          self.ownedNFTs [myToken.id] <-! myToken

        }

        pub fun withdraw(withdrawID:UInt64):@NonFungibleToken.NFT{
            let withdrawNft <- self.ownedNFTs.remove(key:withdrawID) ?? panic("This nft id doesn't exist")
           emit Withdraw(id:withdrawID,from:self.owner?.address)
           return <- withdrawNft
        }


        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
           return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
       }

        pub fun borrowEntireNFT(id: UInt64): &MetaVEvents.NFT {
      let reference = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
      return reference as! &MetaVEvents.NFT
    }

        pub fun getIDs(): [UInt64] {
          return self.ownedNFTs.keys
        }



        init(){
          self.ownedNFTs <- {}
        }

        destroy(){
          destroy self.ownedNFTs
       }

}

      pub fun createEmptyCollection():@Collection{
        return <- create Collection()
      }
      pub fun mint(id:UInt64,maxCount:UInt64,metadata:{String:String}):@MetaVEvents.NFT{
        return <- create NFT(_nftId:id,_maxCount:maxCount,_metadata:metadata)
      }

     pub fun mintEvent(eventId:UInt64,maxCount:UInt64,cid:{String:String}):@MetaVEvents.NFT{
       return <- MetaVEvents.mint(id:eventId,maxCount:maxCount,metadata:cid)
     }

     pub fun mintNft(assetId:UInt64,nftPrice:UInt64,cid:String){

     }
     pub fun buyNft(assetId:UInt64,nftPrice:UInt64,cid:String){

     }

     pub fun mintTicket(ticketId:UInt64,eventId:UInt64,cid:String){

     }

     pub fun mintCertificate(CertificateId:[UInt64],Attendees:[Address],cid:[String]){

     }

 }
