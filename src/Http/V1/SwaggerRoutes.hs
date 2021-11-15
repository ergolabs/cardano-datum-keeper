module Http.V1.SwaggerRoutes where

import Servant
import Servant.Swagger
import Control.Lens
import Servant.Swagger.UI
import Http.V1.DatumRoutes
import Data.Swagger

type ApplicationApi = DatumAPI

applicationApiProxy :: Proxy ApplicationApi
applicationApiProxy = Proxy

type SwaggerAPI = SwaggerSchemaUI "swagger-ui" "swagger.json"

v1Swagger :: Swagger
v1Swagger =
  toSwagger applicationApiProxy
    & info . title .~ "Ergo labs. Cardano datum keeper API"
    & info . version .~ "1.0"
    & info . description ?~ "Description"
    & info . license ?~ ("MIT" & url ?~ URL "http://mit.com")