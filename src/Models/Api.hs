{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE Strict #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UndecidableInstances #-}

module Models.Api where

import Control.Lens
import Data.Aeson
import Data.Swagger
import Database.PostgreSQL.Simple.FromField (FromField (..))
import Database.PostgreSQL.Simple.FromRow (FromRow (..), field)
import GHC.Base (mzero)
import GHC.Generics
import Models.Common
import Servant
import Servant.Swagger

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
