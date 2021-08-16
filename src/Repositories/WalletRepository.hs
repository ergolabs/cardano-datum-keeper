module Repositories.WalletRepository where

import Models.Api
import Models.Common

data WalletRepository = WalletRepository
  { getWalletById :: Id -> IO (Maybe ApiWallet)
  }
