{-# LANGUAGE RecordWildCards #-}

module Services.DatumService
  ( DatumService(..)
  , mkDatumService
  ) where

import RIO ((<&>))
import Control.Monad.Except

import           Repositories.DatumRepository ( DatumRepository(..) )
import qualified Models.Db                    as DB
import           Models.Api                   ( SerializedDatum, deserialiseDatum )

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
    (deserialiseDatum d <&> DB.datumToPersistence)
