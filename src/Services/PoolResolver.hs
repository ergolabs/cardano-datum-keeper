{-# LANGUAGE RecordWildCards #-}

module Services.PoolResolver where

import Dex.Models
import Repositories.PoolRepository

data PoolResolver = PoolResolver { getPoolTxOuts :: IO [FullTxOut] }

mkPoolResolver :: PoolRepository -> PoolResolver
mkPoolResolver repo = PoolResolver (getPoolTxOuts' repo)

getPoolTxOuts' :: PoolRepository -> IO [FullTxOut]
getPoolTxOuts' PoolRepository{..} = getPoolTxOuts