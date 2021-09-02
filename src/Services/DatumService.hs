module Services.DatumService where

import Plutus.V1.Ledger.Scripts  (Datum (..), DatumHash (..))

data DatumService = DatumService {
    putDatum :: Datum -> IO (),
    getDatum :: DatumHash -> IO (Maybe Datum)
  }