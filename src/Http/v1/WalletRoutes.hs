{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module WalletRoutes where

import Prelude ()
import Models.Common
import Models.Api
import Servant.API
  
type WalletAPI = "wallet" :> Capture "walletId" Id :> Get '[JSON] [ApiWallet]