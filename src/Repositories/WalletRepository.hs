module Repositories.WalletRepository where

import Models.Api
import Models.Common
import GHC.Types (IO)
import Database.PostgreSQL.Simple

data WalletRepository = WalletRepository
  { getWalletById :: Id -> IO (Maybe ApiWallet)
  }

mkWalletRepository :: Connection -> WalletRepository
mkWalletRepository conn = WalletRepository mockGetWalletById

mockGetWalletById :: Id -> IO (Maybe ApiWallet)
mockGetWalletById (Id value) = pure $ Just $ ApiWallet value 10