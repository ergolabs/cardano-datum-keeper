{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.DatumRoutes where
  
import Plutus.V1.Ledger.Scripts  (Datum (..), DatumHash(..))
import Control.Monad.Trans.Except (throwE)
import Data.Maybe (Maybe (..))
import Control.Monad.IO.Class   (MonadIO, liftIO)
import Prelude (return, undefined)
import GHC.Base (($))

import Servant
import Services.DatumService
import Servant.API

type DatumAPI = "datumRoutes" :> ( "put" :> ReqBody '[JSON] Datum :> Post '[JSON] () :<|> "get" :> ReqBody '[JSON] DatumHash :> Post '[JSON] Datum)

datumApi :: Proxy DatumAPI
datumApi = Proxy

mkDatumApiServer :: DatumService -> Server DatumAPI
mkDatumApiServer DatumService{..} = put :<|> findDatum
  where
    findDatum :: DatumHash -> Handler Datum
    findDatum datHash = do
      posDatum <- liftIO $ getDatum datHash
      case posDatum of
        Just datum -> return datum
        Nothing -> Handler (throwE $ err401 {errBody = "Could not find datum with that hash"})

    put :: Datum -> Handler ()
    put dat = liftIO $ putDatum dat