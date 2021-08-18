{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE DeriveAnyClass #-}

module Models.Api where

import Data.Aeson
import GHC.Generics
import Models.Common
import Database.PostgreSQL.Simple.FromRow (FromRow (..), field)
import Database.PostgreSQL.Simple.FromField (FromField)

-- drafts

data ApiBlock = ApiBlock
  { id :: Id,
    txQty :: Integer
  }
  deriving (Generic, Show, FromRow, FromField)

instance ToJSON ApiBlock

data ApiTransaction = ApiTransaction
  { id :: Id,
    testInfo :: Integer
  }
  deriving (Generic, Show)

instance ToJSON ApiTransaction

data ApiWallet = ApiWallet
  { id :: Id,
    testInfo :: Integer
  }
  deriving (Generic, Show)

instance ToJSON ApiWallet
