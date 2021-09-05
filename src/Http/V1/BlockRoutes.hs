{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.BlockRoutes where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Except (throwE)
import Data.Maybe (Maybe (..))
import GHC.Base (($))
import Models.Api
import Models.Common
import Servant
import Servant.API
import Servant.Server
import Services.BlocksResolver
import Prelude (return)
import GHC.Base

type BlockAPI = "blocks" :> (Capture "blockId" Id :> Get '[JSON] ApiBlock :<|> "getBestHeight" :> Get '[JSON] Int)

blockAPI :: Proxy BlockAPI
blockAPI = Proxy

mkBlockApiServer :: BlocksResolver -> Server BlockAPI
mkBlockApiServer BlocksResolver {..} = resolveBlock :<|> resolveBestHeight
  where
    resolveBlock :: Id -> Handler ApiBlock
    resolveBlock id = do
      maybeBlock <- liftIO $ getBlockById id
      case maybeBlock of
        Just block -> return block
        Nothing -> Handler (throwE $ err401 {errBody = "Could not find block with that ID"})

    resolveBestHeight :: Handler Int
    resolveBestHeight = liftIO getBestBlockId
