module Services.PoolResolver where

import Dex.Models  
  
data PoolResolver = PoolResolver { getPoolTxOuts :: IO [FullTxOut] }

mkPoolResolver :: PoolResolver
mkPoolResolver = PoolResolver getPoolTxOuts'

getPoolTxOuts' :: IO [FullTxOut]
getPoolTxOuts' = pure []