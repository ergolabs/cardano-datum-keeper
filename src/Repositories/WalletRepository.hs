module Repositories.WalletRepository where

import Models.Api
import Models.Common
import GHC.Types (IO)

data WalletRepository = WalletRepository
  { getWalletById :: Id -> IO (Maybe ApiWallet)
  }

mkWalletRepository :: WalletRepository
mkWalletRepository = WalletRepository mockGetWalletById

mockGetWalletById :: Id -> IO (Maybe ApiWallet)
mockGetWalletById id = pure $ Just $ ApiWallet id 10