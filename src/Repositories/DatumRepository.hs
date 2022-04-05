{-# LANGUAGE OverloadedStrings #-}

module Repositories.DatumRepository
  ( DatumRepository(..)
  , mkDatumRepository
  ) where

import           Data.Functor
import           Database.PostgreSQL.Simple
import           Models.Db
import           Control.Monad.IO.Class

data DatumRepository f = DatumRepository
  { putDatum :: DbDatum -> f ()
  }

mkDatumRepository :: (MonadIO f) => Connection -> DatumRepository f
mkDatumRepository conn = DatumRepository (putDatum' conn)

putDatum' :: (MonadIO f) => Connection -> DbDatum -> f ()
putDatum' con DbDatum{..} =
  void $ liftIO
    $ execute con "insert into datum (datum_hash, datum_json, datum_bytes) values (?, ?, ?)"
    (show dbDatumHash, dbDatumJson, dbDatumBytes)
