module Services.PoolResolver where

import Dex.Models
import Repositories.PoolRepository

data PoolResolver = PoolResolver { getPoolTxOuts :: IO [FullTxOut] }

mkPoolResolver :: PoolRepository -> PoolResolver
mkPoolResolver _ = PoolResolver getPoolTxOuts'

getPoolTxOuts' :: IO [FullTxOut]
getPoolTxOuts' = pure []