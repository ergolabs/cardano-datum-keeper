{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Models.Api where

import Data.Aeson
import GHC.Generics
import Models.Common

-- drafts

data ApiBlock = ApiBlock
  { id :: Id,
    txQty :: Integer
  }
  deriving (Generic, Show)

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
