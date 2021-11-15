{-# LANGUAGE RecordWildCards #-}

module Services.DatumService
  ( DatumService(..)
  , mkDatumService
  ) where

import Plutus.V1.Ledger.Scripts      (Datum (..), DatumHash (..))
import Repositories.DatumRepository

data DatumService f = DatumService
  { putDatum :: Datum -> f ()
  }

mkDatumService :: DatumRepository f -> DatumService f
mkDatumService repo = DatumService (putDatum' repo)

putDatum' :: DatumRepository f -> Datum -> f ()
putDatum' DatumRepository {..} = putDatum