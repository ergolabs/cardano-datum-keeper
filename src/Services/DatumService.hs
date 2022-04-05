{-# LANGUAGE RecordWildCards #-}

module Services.DatumService
  ( DatumService(..)
  , mkDatumService
  ) where

import Control.Monad.Except

import Repositories.DatumRepository ( DatumRepository(..) )
import qualified Models.Db                    as DBDatum
import Models.Api ( SerializedDatum, deserialiseDatum )
import RIO ((<&>))
import Servant.Server (ServerError(..), err400)

data DatumService f = DatumService
  { putDatum :: SerializedDatum -> ExceptT ServerError f ()
  }

mkDatumService :: Monad f => DatumRepository f -> DatumService f
mkDatumService repo = DatumService (putDatum' repo)

putDatum' :: Monad f => DatumRepository f -> SerializedDatum -> ExceptT ServerError f ()
putDatum' DatumRepository {..} d =
  maybe
    (throwError err400 { errBody = "Cannot decode provided datum." }) 
    (lift . putDatum)
    (deserialiseDatum d <&> DBDatum.fromDatum)
