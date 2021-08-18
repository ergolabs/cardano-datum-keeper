{-# LANGUAGE RecordWildCards #-}

module Services.BlocksResolver where

import Models.Api
import Models.Common
import Repositories.BlockRepository

data BlocksResolver = BlocksResolver
  { getBlockById :: Id -> IO (Maybe ApiBlock),
    getBlockByHash :: Hash -> IO (Maybe ApiBlock)
  }

mkBlockResolver :: BlockRepository -> BlocksResolver
mkBlockResolver repo = BlocksResolver (getBlockById' repo) (getBlockByHash' repo)

getBlockById' :: BlockRepository -> Id -> IO (Maybe ApiBlock)
getBlockById' BlockRepository{..} = getBlockById

getBlockByHash' :: BlockRepository -> Hash -> IO (Maybe ApiBlock)
getBlockByHash' BlockRepository{..} = getBlockByHash

