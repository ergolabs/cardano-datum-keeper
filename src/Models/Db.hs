module Models.Db where

import           RIO
import qualified Data.ByteString      as B
import qualified PlutusTx.Builtins    as Builtins
import qualified Data.ByteString.Lazy as BL
import           Data.Aeson           (encode)

import qualified Codec.Serialise as S

import Ledger.Scripts (Datum (..), DatumHash (..), datumHash)

data DbDatum = DbDatum
  { dbDatumHash  :: DatumHash
  , dbDatumJson  :: ByteString
  , dbDatumBytes :: ByteString
  }

fromDatum :: Datum -> DbDatum
fromDatum dt =
  DbDatum
    { dbDatumHash  = datumHash dt
    , dbDatumJson  = B.concat . BL.toChunks $ encode dt
    , dbDatumBytes = BL.toStrict $ S.serialise dt
    }
