{-# LANGUAGE OverloadedStrings #-}

module Repositories.TransactionRepository where

import Models.Api
import Models.Common
import Database.PostgreSQL.Simple

data TransactionRepository = TransactionRepository
  { getTransactionById :: Id -> IO (Maybe ApiTransaction)
  }

mkTransactionRepository :: Connection -> TransactionRepository
mkTransactionRepository conn = TransactionRepository (mkGetTransactionByIdMock conn)

mkGetTransactionByIdMock :: Connection -> Id -> IO (Maybe ApiTransaction)
mkGetTransactionByIdMock conn (Id value) = do
  results <- (query conn "SELECT id, fee FROM tx WHERE id = ?" $ (Only value)) :: IO [(Int, Int)]
  case results of
    [(id, fee)] -> pure $ Just $ ApiTransaction id fee
    _ -> pure Nothing