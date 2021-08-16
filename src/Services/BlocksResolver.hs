{-# LANGUAGE RecordWildCards #-}

module Services.BlocksResolver where

import Models.Api
import Models.Common
import Repositories.BlockRepository

data BlockResolver = BlockResolver
  { getBlockById :: Id -> IO (Maybe ApiBlock),
    getBlockByHash :: Hash -> IO (Maybe ApiBlock)
  }

mkBlockResolver :: BlockRepository -> BlockResolver
mkBlockResolver repo = BlockResolver (getBlockById' repo) (getBlockByHash' repo)

getBlockById' :: BlockRepository -> Id -> IO (Maybe ApiBlock)
getBlockById' BlockRepository{..} = getBlockById

getBlockByHash' :: BlockRepository -> Hash -> IO (Maybe ApiBlock)
getBlockByHash' BlockRepository{..} = getBlockByHash

