{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE Strict #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Models.Api where

import Dex.Models
import Data.Aeson (ToJSON, FromJSON, toJSON, ToJSONKey)
import Control.Lens
import Plutus.V1.Ledger.Address    (Address (..))
import qualified PlutusTx.AssocMap  as Map
import Plutus.V1.Ledger.Value
import Plutus.V1.Ledger.Scripts (ValidatorHash(..), DatumHash(..))
import Plutus.V1.Ledger.Crypto  (PubKeyHash(..))
import Plutus.V1.Ledger.Credential (StakingCredential(..), Credential(..))
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

instance ToSchema Datum

instance ToSchema Address where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "Address description"
      & mapped . schema . example ?~ toJSON mockAddress

instance ToSchema PlutusTx.Data where
    declareNamedSchema _ = return $ NamedSchema (Just "plutus.data") byteSchema

instance ToSchema GId where
  declareNamedSchema proxy =
    genericDeclareNamedSchema defaultSchemaOptions proxy
      & mapped . schema . description ?~ "GId description"
      & mapped . schema . example ?~ toJSON (GId 1)

instance ToSchema TxId where
    declareNamedSchema _ = return $ NamedSchema (Just "txId") byteSchema

instance ToSchema ValidatorHash where
    declareNamedSchema _ = return $ NamedSchema (Just "ValidatorHash") byteSchema

instance ToSchema DatumHash where
    declareNamedSchema _ = return $ NamedSchema (Just "DatumHash") byteSchema

instance ToSchema PubKeyHash where
    declareNamedSchema _ = return $ NamedSchema (Just "PubKeyHash") byteSchema

instance ToSchema Credential

instance ToSchema StakingCredential where
  declareNamedSchema _ = return $ NamedSchema (Just "StakingCredential") $ mempty

instance ToSchema Value where
  declareNamedSchema _ = return $ NamedSchema (Just "Value") $ mempty

instance ToSchema TokenName where
  declareNamedSchema _ = return $ NamedSchema (Just "TokenName") byteSchema

instance ToSchema CurrencySymbol where
  declareNamedSchema _ = return $ NamedSchema (Just "CurrencySymbol") byteSchema

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
