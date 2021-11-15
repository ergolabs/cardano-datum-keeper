{-# LANGUAGE OverloadedStrings #-}

module Repositories.DatumRepository
  ( DatumRepository(..)
  , mkDatumRepository
  ) where

import           Plutus.V1.Ledger.Scripts            (Datum (..), DatumHash (..), datumHash)
import           Data.Maybe                          (Maybe (..))
import           Data.Aeson                          (decode)
import qualified Data.ByteString                     as B
import qualified PlutusTx.Builtins                   as Builtins
import qualified Data.ByteString.Lazy                as BL
import           Data.Aeson                          (encode)
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.FromRow
import           Database.PostgreSQL.Simple.ToRow
import           GHC.Base                            (($))
import           Models.Api
import           Control.Monad.IO.Class
  
data DatumRepository f = DatumRepository
  { putDatum :: Datum -> f ()
  }
  
mkDatumRepository :: (MonadIO f) => Connection -> DatumRepository f
mkDatumRepository conn = DatumRepository (putDatum' conn)

putDatum' :: (MonadIO f) => Connection -> Datum -> f ()
putDatum' con dat = do
  let jsonDatum = B.concat . BL.toChunks $ encode dat
  liftIO $ execute con "insert into datum (datum_hash, datum_json) values (?, ?)" $ (show $ datumHash dat, jsonDatum)
  return ()

