{-# LANGUAGE RecordWildCards #-}

module Services.DatumService
  ( DatumService(..)
  , mkDatumService
  ) where

import           Ledger.Scripts               (Datum (..), DatumHash (..))
import           Repositories.DatumRepository
import qualified Models.Db                    as DBDatum

data DatumService f = DatumService
  { putDatum :: Datum -> f ()
  }

mkDatumService :: DatumRepository f -> DatumService f
mkDatumService repo = DatumService (putDatum' repo)

putDatum' :: DatumRepository f -> Datum -> f ()
putDatum' DatumRepository {..} = putDatum . DBDatum.fromDatum
