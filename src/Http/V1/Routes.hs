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
import Servant
import Servant.Swagger
import Servant.Swagger.UI
import Services.BlocksResolver
import Services.TransactionResolver
import Services.WalletResolver

type ApplicationApi = BlockAPI :<|> TransactionAPI :<|> WalletAPI

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

mkApiServer :: BlocksResolver -> TransactionResolver -> WalletResolver -> Server API
mkApiServer blockR txR walletR = swaggerSchemaUIServer todoSwagger :<|> mkBlockApiServer blockR :<|> mkTransactionAPIServer txR :<|> mkWalletApiServer walletR
