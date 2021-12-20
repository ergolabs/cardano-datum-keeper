{-# LANGUAGE OverloadedStrings #-}

module Repositories.DatumRepository
  ( DatumRepository(..)
  , mkDatumRepository
  ) where

import           Data.Functor
import           Data.Maybe                          (Maybe (..))
import           Data.Aeson                          (decode)
import qualified Data.ByteString                     as B
import qualified PlutusTx.Builtins                   as Builtins
import qualified Data.ByteString.Lazy                as BL
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.FromRow
import           Database.PostgreSQL.Simple.ToRow
import           GHC.Base                            (($))
import           Models.Api
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
    $ execute con "insert into datum (datum_hash, datum_json, datum_bytes) values (?, ?)"
    $ (show $ dbDatumHash, dbDatumJson, dbDatumBytes)

