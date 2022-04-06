{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.DatumRoutes where
  
import Control.Monad.Trans.Except (ExceptT)

import Servant
import Services.DatumService
import Models.Api (SerializedDatum)

type DatumAPI = "datum" :> ( "report" :> ReqBody '[JSON] SerializedDatum :> Post '[JSON] ())

datumApi :: Proxy DatumAPI
datumApi = Proxy

mkDatumApiServer :: DatumService f -> ServerT DatumAPI (ExceptT ServerError f)
mkDatumApiServer DatumService{..} = putDatum
