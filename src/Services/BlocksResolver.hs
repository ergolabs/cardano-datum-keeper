module Services.BlocksResolver where

import Models.Api
import Models.Common

data BlockResolver = BlockResolver
  { getBlockById :: Id -> Maybe ApiBlock,
    getBlockByHash :: Hash -> Maybe ApiBlock
  }
