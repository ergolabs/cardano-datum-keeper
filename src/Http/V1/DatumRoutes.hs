{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.DatumRoutes where
  
import Plutus.V1.Ledger.Scripts    (Datum (..), DatumHash(..))
import Control.Monad.Trans.Except  (throwE)
import Data.Maybe                  (Maybe (..))
import Prelude                     (return, undefined)
import GHC.Base                    (($))

import Servant
import Services.DatumService
import Servant.API

type DatumAPI = "datumRoutes" :> ( "put" :> ReqBody '[JSON] Datum :> Post '[JSON] ())

datumApi :: Proxy DatumAPI
datumApi = Proxy

mkDatumApiServer :: DatumService f -> ServerT DatumAPI f
mkDatumApiServer DatumService{..} = putDatum