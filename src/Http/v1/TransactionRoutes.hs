{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module TransactionRoutes where
  
import Prelude ()
import Models.Common
import Models.Api
import Servant.API
  
type TransactionAPI = "transaction" :> Capture "transactionId" Id :> Get '[JSON] [ApiTransaction]

