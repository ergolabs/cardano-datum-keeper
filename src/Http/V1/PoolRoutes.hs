{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.PoolRoutes where

import Services.PoolResolver
import Control.Monad.IO.Class (liftIO)
import Servant.Server
import Dex.Models
import Servant
import Servant.API
  
type PoolAPI = "poolRoutes" :> Get '[JSON] [FullTxOut]

poolApi :: Proxy PoolAPI
poolApi = Proxy

mkPoolApiServer :: PoolResolver -> Server PoolAPI
mkPoolApiServer PoolResolver{..} = getTxOuts
  where
    getTxOuts :: Handler [FullTxOut]
    getTxOuts = liftIO getPoolTxOuts
