module Repositories.TransactionRepository where

import Models.Api
import Models.Common  
  
data TransactionRepository = TransactionRepository
  { getTransactionById :: Id -> IO (Maybe ApiTransaction)
  }
  
mkTransactionRepository :: TransactionRepository
mkTransactionRepository = TransactionRepository mkGetTransactionByIdMock

mkGetTransactionByIdMock :: Id -> IO (Maybe ApiTransaction)
mkGetTransactionByIdMock id = pure $ Just $ ApiTransaction id 10