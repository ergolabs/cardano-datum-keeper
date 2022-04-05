{-# LANGUAGE TemplateHaskell            #-}

module Models.Db where

import           RIO
import qualified Data.ByteString         as B
import qualified Data.ByteString.Lazy    as BL
import           Data.Aeson              as Json
import qualified Data.Text.Encoding      as T
import qualified Data.ByteString.Base16  as Hex
import           Data.ByteArray as BA

import qualified Cardano.Api         as C
import qualified Cardano.Api.Shelley as C

import qualified Codec.Serialise as S
import qualified PlutusTx
import           Ledger.Scripts  (Datum (..), DatumHash (..), datumHash)

data DbDatum = DbDatum
  { dbDatumHash  :: Text
  , dbDatumJson  :: ByteString
  , dbDatumBytes :: Text
  }

datumToPersistence :: Datum -> DbDatum
datumToPersistence d =
  let DatumHash dh = datumHash d
  in DbDatum
    { dbDatumHash  = T.decodeUtf8 . Hex.encode . B.pack . BA.unpack $ dh
    , dbDatumJson  = BL.toStrict
                      . Json.encode
                      . C.scriptDataToJson C.ScriptDataJsonDetailedSchema
                      . C.fromPlutusData
                      . PlutusTx.toData $ d
    , dbDatumBytes = T.decodeUtf8 . Hex.encode . BL.toStrict . S.serialise $ d
    }
