{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE RecordWildCards #-}

module Http.V1.Routes where

import Control.Lens
import Data.Proxy
import Data.Swagger
import Http.V1.DatumRoutes
import Servant
import Servant.Swagger
import Servant.Swagger.UI
import Settings.AppSettings
import Control.Monad.IO.Class    (MonadIO, liftIO)
import Network.Wai.Handler.Warp  as Warp
import Http.V1.SwaggerRoutes

type API = SwaggerAPI :<|> ApplicationApi

apiV1Proxy :: Proxy API
apiV1Proxy = Proxy
