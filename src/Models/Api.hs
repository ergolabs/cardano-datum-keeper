{-# LANGUAGE DuplicateRecordFields #-}

module Models.Api where

import Models.Common

-- drafts

data ApiBlock = ApiBlock {
  id :: Id,
  txQty :: Integer
}

data ApiTransaction = ApiTransaction {
  id :: Id,
  testInfo :: Integer
}

data ApiWallet = ApiWallet {
  id :: Id,
  testInfo :: Integer
}