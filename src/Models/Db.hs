module Models.Db where

import           RIO
import qualified Data.ByteString         as B
import qualified Data.ByteString.Lazy    as BL
import           Data.Aeson              (encode)
import qualified Data.Text.Encoding      as T
import qualified Data.ByteString.Base16  as Hex
import Data.ByteArray as BA

import qualified Codec.Serialise as S

import Ledger.Scripts (Datum (..), DatumHash (..), datumHash)

data DbDatum = DbDatum
  { dbDatumHash  :: ByteString
  , dbDatumJson  :: ByteString
  , dbDatumBytes :: Text
  }

fromDatum :: Datum -> DbDatum
fromDatum d =
  let DatumHash dh = datumHash d
  in DbDatum
    { dbDatumHash  = Hex.encode . B.pack . BA.unpack $ dh
    , dbDatumJson  = BL.toStrict . encode $ d
    , dbDatumBytes = T.decodeUtf8 . Hex.encode . BL.toStrict . S.serialise $ d
    }
