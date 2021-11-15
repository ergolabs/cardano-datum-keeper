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
import Http.V1.DatumRoutes
import Servant
import Servant.Swagger
import Servant.Swagger.UI
import Services.DatumService

type ApplicationApi = DatumAPI

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

mkApiServer :: DatumService -> Server API
mkApiServer datumS = swaggerSchemaUIServer todoSwagger :<|> mkDatumApiServer datumS
