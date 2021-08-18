module Repositories.BlockRepository where

import Models.Api
import Models.Common
import GHC.Base (($))
import Database.PostgreSQL.Simple

data BlockRepository = BlockRepository
  { getBlockById :: Id -> IO (Maybe ApiBlock),
    getBlockByHash :: Hash -> IO (Maybe ApiBlock)
  }
  
mkBlockRepository :: Connection -> BlockRepository
mkBlockRepository conn = BlockRepository mockGetBlockById mockGetBlockByHash

mockGetBlockById :: Id -> IO (Maybe ApiBlock)
mockGetBlockById id = pure $ Just $ ApiBlock id 10

mockGetBlockByHash :: Hash -> IO (Maybe ApiBlock)
mockGetBlockByHash _ = pure $ Just $ ApiBlock (Id 1) 10