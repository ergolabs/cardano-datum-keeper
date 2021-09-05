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
    getDatum :: DatumHash -> IO (Maybe Datum)
  }
  
mkDatumRepository :: Connection -> DatumRepository
mkDatumRepository conn = DatumRepository (putDatum' conn) (getDatum' conn)

putDatum' :: Connection -> Datum -> IO ()
putDatum' con dat = do
  let jsonDatum = B.concat . BL.toChunks $  encode dat
  execute con "insert into datum (datum_hash, datum_json) values (?, ?)" $ (show $ datumHash dat, jsonDatum)
  return ()

getDatum' :: Connection -> DatumHash -> IO (Maybe Datum)
getDatum' conn datHash = do
  let datHashShow = show datHash
  results <- query conn "SELECT datum_json FROM datum WHERE datum_hash = (?)" $ (Only datHashShow) :: IO [Only Builtins.ByteString]
  case results of
    [Only datJson] -> pure $ ((decode $ BL.fromStrict datJson) :: Maybe Datum)
    _ -> pure Nothing

