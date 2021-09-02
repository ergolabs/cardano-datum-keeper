{-# LANGUAGE OverloadedStrings #-}

module Repositories.BlockRepository where

import Data.Maybe (Maybe (..))
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import GHC.Base (($))
import Models.Api
import Models.Common

data BlockRepository = BlockRepository
  { getBlockById :: Id -> IO (Maybe ApiBlock),
    getBlockByHash :: Hash -> IO (Maybe ApiBlock),
    getBestHeight :: IO Int
  }

mkBlockRepository :: Connection -> BlockRepository
mkBlockRepository conn = BlockRepository (retrieveBlockById' conn) (retrieveBlockByHash' conn) (getBestHeight' conn)

retrieveBlockById' :: Connection -> Id -> IO (Maybe ApiBlock)
retrieveBlockById' conn (Id value) = do
  results <- (query conn "SELECT id, tx_count FROM block WHERE id = ?" $ (Only value)) :: IO [(Int, Int)]
  case results of 
    [(id, txQty)] -> pure $ Just $ ApiBlock id txQty
    _ -> pure Nothing

retrieveBlockByHash' :: Connection -> Hash -> IO (Maybe ApiBlock)
retrieveBlockByHash' conn (Hash hash) = do
  results <- query conn "SELECT id, tx_count FROM block WHERE hash = ?" $ (Only hash) :: IO [(Int, Int)]
  case results of 
    [(id, txQty)] -> pure $ Just $ ApiBlock id txQty
    _ -> pure Nothing

getBestHeight' :: Connection -> IO Int
getBestHeight' conn = do
  heights <- (query_ conn "SELECT MAX(id) FROM block") :: IO [Only Int]
  case heights of
    [] -> return (-1)
    [height] -> return ( fromOnly height )
    xs -> return (-1)
