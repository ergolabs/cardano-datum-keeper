{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.DatumRoutes where
  
import Plutus.V1.Ledger.Scripts  (Datum (..))  

import Servant
import Servant.API

type DatumAPI = "datumRoutes" :> "put" :> ReqBody '[JSON] Datum :> Get '[JSON] ()

datumApi :: Proxy DatumAPI
datumApi = Proxy

mkDatumApi :: PoolResolver -> Server PoolAPI