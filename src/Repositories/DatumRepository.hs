{-# LANGUAGE OverloadedStrings #-}

module Repositories.DatumRepository
  ( DatumRepository(..)
  , mkDatumRepository
  ) where

import           Data.Functor
import           Database.PostgreSQL.Simple
import           Models.Db
import           Control.Monad.IO.Class
import Database.PostgreSQL.Simple.ToRow

data DatumRepository f = DatumRepository
  { putDatum :: DbDatum -> f ()
  }

mkDatumRepository :: (MonadIO f) => Connection -> DatumRepository f
mkDatumRepository conn = DatumRepository (putDatum' conn)

putDatum' :: (MonadIO f) => Connection -> DbDatum -> f ()
putDatum' con DbDatum{..} = do
  liftIO $ putStrLn $ show $ toRow (dbDatumHash, dbDatumJson, dbDatumBytes)
  void $ liftIO
    $ execute con "insert into reported_datum (hash, value, raw_value) values (?, ?, ?)"
    (dbDatumHash, dbDatumJson, dbDatumBytes)
