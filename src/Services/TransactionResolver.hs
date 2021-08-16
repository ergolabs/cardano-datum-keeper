module Services.TransactionResolver where

import Models.Api
import Models.Common

data TransactionResolver = TransactionResolver {getTransactionById :: Id -> IO (Maybe ApiTransaction)}

mkTransactionResolver :: IO TransactionResolver
mkTransactionResolver = undefined