{-# LANGUAGE RecordWildCards #-}

module Services.WalletResolver where

import Models.Api
import Models.Common
import Repositories.WalletRepository

data WalletResolver = WalletResolver {getWalletById :: Id -> IO (Maybe ApiWallet)}

mkWalletResolver :: WalletRepository -> WalletResolver
mkWalletResolver repo = WalletResolver (getWalletById' repo)

getWalletById' :: WalletRepository -> Id -> IO (Maybe ApiWallet)
getWalletById' WalletRepository{..} = getWalletById

