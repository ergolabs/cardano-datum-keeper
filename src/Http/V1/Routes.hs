{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.Routes where

import Control.Lens
import Data.Proxy
import Data.Swagger
import Http.V1.BlockRoutes
import Http.V1.TransactionRoutes
import Http.V1.WalletRoutes
import Http.V1.ProxyRoutes
import Http.V1.PoolRoutes
import Http.V1.DatumRoutes
import Servant
import Servant.Swagger
import Servant.Swagger.UI
import Services.BlocksResolver
import Services.TransactionResolver
import Services.WalletResolver
import Services.DatumService
import Services.PoolResolver
import Services.ProxyResolver

type ApplicationApi = BlockAPI :<|> TransactionAPI :<|> WalletAPI :<|> PoolAPI :<|> ProxyAPI :<|> DatumAPI

applicationApiProxy :: Proxy ApplicationApi
applicationApiProxy = Proxy

type SwaggerAPI = SwaggerSchemaUI "swagger-ui" "swagger.json"

type API = SwaggerAPI :<|> ApplicationApi

todoSwagger :: Swagger
todoSwagger =
  toSwagger applicationApiProxy
    & info . title .~ "Ergo labs. Cardano explorer API"
    & info . version .~ "1.0"
    & info . description ?~ "Description"
    & info . license ?~ ("MIT" & url ?~ URL "http://mit.com")

apiProxy :: Proxy API
apiProxy = Proxy

mkApiServer :: BlocksResolver -> TransactionResolver -> WalletResolver -> PoolResolver -> ProxyResolver -> DatumService -> Server API
mkApiServer blockR txR walletR poolR proxyR datumS = swaggerSchemaUIServer todoSwagger :<|> mkBlockApiServer blockR :<|>
  mkTransactionAPIServer txR :<|> mkWalletApiServer walletR :<|>
  mkPoolApiServer poolR :<|> mkProxyApiServer proxyR :<|>
  mkDatumApiServer datumS
