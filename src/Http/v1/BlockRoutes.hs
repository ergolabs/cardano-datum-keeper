{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module BlockRoutes where

import Prelude ()
import Models.Common
import Models.Api
import Servant.API
  
type BlockApi = "block" :> Capture "blockId" Id :> Get '[JSON] [ApiBlock]
