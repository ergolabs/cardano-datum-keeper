module Repositories.TransactionRepository where

import Models.Api
import Models.Common  
import Database.PostgreSQL.Simple
  
data TransactionRepository = TransactionRepository
  { getTransactionById :: Id -> IO (Maybe ApiTransaction)
  }
  
mkTransactionRepository :: Connection -> TransactionRepository
mkTransactionRepository conn = TransactionRepository mkGetTransactionByIdMock

mkGetTransactionByIdMock :: Id -> IO (Maybe ApiTransaction)
mkGetTransactionByIdMock id = pure $ Just $ ApiTransaction id 10