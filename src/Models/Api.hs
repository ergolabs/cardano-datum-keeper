{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE Strict #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UndecidableInstances #-}

module Models.Api where

import Dex.Models
import Data.Aeson (ToJSON, FromJSON, toJSON)
import Control.Lens
import Plutus.V1.Ledger.Address    (Address (..))
import qualified PlutusTx.AssocMap  as Map
import Plutus.V1.Ledger.Value (Value(..), CurrencySymbol(..))
import Plutus.V1.Ledger.Credential (StakingCredential(..))
import qualified PlutusTx.Builtins  as Builtins
import Ledger.Scripts            (Datum (..))
import Plutus.V1.Ledger.TxId (TxId(..))
import Data.Swagger
import Database.PostgreSQL.Simple.FromField (FromField (..))
import Database.PostgreSQL.Simple.FromRow (FromRow (..), field)
import Helpers.MockValues
import GHC.Base (mzero)
import GHC.Generics
import Models.Common
import Servant
import Servant.Swagger
import qualified PlutusTx

-- drafts

data ApiBlock = ApiBlock
  { id :: Int,
    txQty :: Int
  }
  deriving (Generic, Show)

instance FromRow ApiBlock where
  fromRow = ApiBlock <$> field <*> field

instance ToJSON ApiBlock

instance FromJSON ApiBlock

instance ToSchema ApiBlock where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Block description"
      & mapped . schema . example ?~ toJSON (ApiBlock 1 1)

instance ToSchema FullTxOut where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "FullTxOut description"
      & mapped . schema . example ?~ toJSON mockFullTxOut

instance ToSchema TxId where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "FullTxOut description"
      & mapped . schema . example ?~ toJSON (TxId Builtins.emptyByteString)

instance ToSchema Datum where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Datum description"
      & mapped . schema . example ?~ toJSON (Datum $ PlutusTx.toData mockErgoDexPool)

instance ToSchema Value where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Value description"
      & mapped . schema . example ?~ toJSON (Value Map.empty)

instance ToSchema Address where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Address description"
      & mapped . schema . example ?~ toJSON mockAddress

instance ToSchema PlutusTx.Data where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Data description"
      & mapped . schema . example ?~ toJSON (PlutusTx.toData mockErgoDexPool)

instance ToSchema GId where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "GId description"
      & mapped . schema . example ?~ toJSON (GId 1)
 
instance ToSchema CurrencySymbol where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "CurrencySymbol description"
      & mapped . schema . example ?~ toJSON mockCurrencySymbol

instance ToSchema StakingCredential where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "StakingCredential description"
      & mapped . schema . example ?~ toJSON (StakingPtr 1 1 1)
      
instance ToSchema Credential where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "StakingCredential description"
      & mapped . schema . example ?~ toJSON (StakingPtr 1 1 1)

data ApiTransaction = ApiTransaction
  { id :: Int,
    fee :: Int
  }
  deriving (Generic, Show)

instance ToJSON ApiTransaction

instance FromJSON ApiTransaction

instance ToSchema ApiTransaction where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Transaction description"
      & mapped . schema . example ?~ toJSON (ApiTransaction 1 1)

data ApiWallet = ApiWallet
  { id :: Int,
    testInfo :: Int
  }
  deriving (Generic, Show)

instance ToJSON ApiWallet

instance FromJSON ApiWallet

instance ToSchema ApiWallet where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Wallet description"
      & mapped . schema . example ?~ toJSON (ApiWallet 1 1)
