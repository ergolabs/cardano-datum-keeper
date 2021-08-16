module Services.BlocksResolver where

import Models.Api
import Models.Common

data BlockResolver = BlockResolver
  { getBlockById :: Id -> IO (Maybe ApiBlock),
    getBlockByHash :: Hash -> IO (Maybe ApiBlock)
  }

mkBlockResolver :: IO BlockResolver
mkBlockResolver = undefined