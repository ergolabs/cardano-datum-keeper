{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE RecordWildCards #-}

module Http.V1.Routes where

import Data.Proxy
import Servant
import Http.V1.SwaggerRoutes

type API = SwaggerAPI :<|> ApplicationApi

apiV1Proxy :: Proxy API
apiV1Proxy = Proxy
