{-# LANGUAGE RecordWildCards #-}

module Services.DatumService (DatumService(..), mkDatumService) where

import Plutus.V1.Ledger.Scripts  (Datum (..), DatumHash (..))
import Repositories.DatumRepository

data DatumService = DatumService {
    putDatum :: Datum -> IO (),
  }

mkDatumService :: DatumRepository -> DatumService
mkDatumService repo = DatumService (putDatum' repo) (getDatum' repo)

putDatum' :: DatumRepository -> Datum -> IO ()
putDatum' DatumRepository {..} = putDatum