module Services.WalletResolver where

import Models.Api
import Models.Common

data WalletResolver = WalletResolver {getWalletById :: Id -> IO (Maybe ApiWallet)}

mkWalletResolver :: IO WalletResolver
mkWalletResolver = undefined