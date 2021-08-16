{-# LANGUAGE RecordWildCards #-}

module Services.TransactionResolver where

import Models.Api
import Models.Common
import Repositories.TransactionRepository

data TransactionResolver = TransactionResolver {getTransactionById :: Id -> IO (Maybe ApiTransaction)}

mkTransactionResolver :: TransactionRepository -> TransactionResolver
mkTransactionResolver repo = TransactionResolver (getTransactionById' repo)

getTransactionById' :: TransactionRepository -> Id -> IO (Maybe ApiTransaction)
getTransactionById' TransactionRepository{..} = getTransactionById