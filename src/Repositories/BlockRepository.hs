module Repositories.BlockRepository where

import Models.Api
import Models.Common  
  
data BlockRepository = BlockRepository
  { getBlockById :: Id -> IO (Maybe ApiBlock),
    getBlockByHash :: Hash -> IO (Maybe ApiBlock)
  }
