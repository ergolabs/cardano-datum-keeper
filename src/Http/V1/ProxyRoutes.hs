{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.ProxyRoutes where

import Dex.Models
import Control.Monad.IO.Class (liftIO)
import GHC.Base (($))
import Services.ProxyResolver
import Servant.Server
import Prelude (return)
import Servant
import Servant.API

type ProxyAPI = "proxyContracts" :> Get '[JSON] [FullTxOut]

proxyApi :: Proxy ProxyAPI
proxyApi = Proxy

mkProxyApiServer :: ProxyResolver -> Server ProxyAPI
mkProxyApiServer ProxyResolver{..} = getTxOuts
  where
    getTxOuts :: Handler [FullTxOut]
    getTxOuts = liftIO getProxyTxOuts

