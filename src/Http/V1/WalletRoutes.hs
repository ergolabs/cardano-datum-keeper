{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.WalletRoutes where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Except (throwE)
import Data.Maybe (Maybe (..))
import GHC.Base (($))
import Models.Api
import Models.Common
import Servant
import Servant.API
import Servant.Server
import Services.WalletResolver
import Prelude (return)

type WalletAPI = "wallet" :> Capture "walletId" Id :> Get '[JSON] ApiWallet

walletAPI :: Proxy WalletAPI
walletAPI = Proxy

mkWalletApiServer :: WalletResolver -> Server WalletAPI
mkWalletApiServer WalletResolver {..} = resolveWallet
  where
    resolveWallet :: Id -> Handler ApiWallet
    resolveWallet id = do
      maybeWallet <- liftIO $ getWalletById id
      case maybeWallet of
        Just wallet -> return wallet
        Nothing -> Handler (throwE $ err401 {errBody = "Could not find wallet with that ID"})
