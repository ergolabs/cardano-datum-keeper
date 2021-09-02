module Repositories.DatumRepository where

import Plutus.V1.Ledger.Scripts  (Datum (..), DatumHash (..))  
  
data DatumRepository = DatumRepository { 
    putDatum :: Datum -> IO (), 
    getDatum :: DatumHash -> IO (Maybe Datum)
  }
