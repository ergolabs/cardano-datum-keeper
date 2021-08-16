module Repositories.TransactionRepository where

import Models.Api
import Models.Common  
  
data TransactionRepository = TransactionRepository
  { getTransactionById :: Id -> IO (Maybe ApiTransaction)
  }
