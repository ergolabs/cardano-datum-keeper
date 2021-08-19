{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Http.V1.TransactionRoutes where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Except (throwE)
import Data.Maybe (Maybe (..))
import GHC.Base (($))
import Models.Api
import Models.Common
import Servant
import Servant.API
import Servant.Server
import Services.TransactionResolver
import Prelude (return)

type TransactionAPI = "transaction" :> Capture "transactionId" Id :> Get '[JSON] ApiTransaction

transactionAPI :: Proxy TransactionAPI
transactionAPI = Proxy

mkTransactionAPIServer :: TransactionResolver -> Server TransactionAPI
mkTransactionAPIServer TransactionResolver {..} = resolveTxById
  where
    resolveTxById :: Id -> Handler ApiTransaction
    resolveTxById id = do
      maybeTx <- liftIO $ getTransactionById id
      case maybeTx of
        Just tx -> return tx
        Nothing -> Handler (throwE $ err401 {errBody = "Could not find transaction with that ID"})
