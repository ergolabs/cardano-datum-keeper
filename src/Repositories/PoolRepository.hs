module Repositories.PoolRepository (PoolRepository(..), mkPoolRepository) where

import Dex.Models
import Database.PostgreSQL.Simple

data PoolRepository = PoolRepository { getPoolTxOuts :: IO [FullTxOut] }

mkPoolRepository :: Connection -> PoolRepository
mkPoolRepository _ = PoolRepository getPoolTxOuts'

getPoolTxOuts' :: IO [FullTxOut]
getPoolTxOuts' = pure []


