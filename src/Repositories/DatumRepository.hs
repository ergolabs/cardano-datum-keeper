{-# LANGUAGE OverloadedStrings #-}

module Repositories.DatumRepository (DatumRepository(..), mkDatumRepository) where

import Plutus.V1.Ledger.Scripts  (Datum (..), DatumHash (..), datumHash)
import Data.Maybe (Maybe (..))
import Data.Aeson (decode)
import qualified Data.ByteString               as B
import qualified PlutusTx.Builtins             as Builtins
import qualified Data.ByteString.Lazy          as BL
import Data.Aeson (encode)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import GHC.Base (($))
import Models.Api
import Models.Common 
  
data DatumRepository = DatumRepository { 
    putDatum :: Datum -> IO (), 
  }
  
mkDatumRepository :: Connection -> DatumRepository
mkDatumRepository conn = DatumRepository (putDatum' conn)

putDatum' :: Connection -> Datum -> IO ()
putDatum' con dat = do
  let jsonDatum = B.concat . BL.toChunks $ encode dat
  execute con "insert into datum (datum_hash, datum_json) values (?, ?)" $ (show $ datumHash dat, jsonDatum)
  return ()

