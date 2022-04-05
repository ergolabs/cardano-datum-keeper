{-# LANGUAGE OverloadedStrings #-}

module Repositories.DatumRepository
  ( DatumRepository(..)
  , mkDatumRepository
  ) where

import RIO (throwIO)

import           Data.Functor
import           Database.PostgreSQL.Simple
import           Models.Db
import           Control.Monad.IO.Class
import Database.PostgreSQL.Simple.Errors

data DatumRepository f = DatumRepository
  { putDatum :: DbDatum -> f ()
  }

mkDatumRepository :: (MonadIO f) => Connection -> DatumRepository f
mkDatumRepository conn = DatumRepository (putDatum' conn)

putDatum' :: (MonadIO f) => Connection -> DbDatum -> f ()
putDatum' con DbDatum{..} =
    liftIO
      $ catchViolation catcher
      $ void
      $ execute con "insert into reported_datum (hash, value, raw_value) values (?, ?, ?)" (dbDatumHash, dbDatumJson, dbDatumBytes)
  where
    catcher _ (UniqueViolation _) = pure ()
    catcher e _                   = throwIO e
