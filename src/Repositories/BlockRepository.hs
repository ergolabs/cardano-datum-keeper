{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}

module Repositories.BlockRepository where

import Data.Maybe (Maybe (..))
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import GHC.Base (($))
import Models.Api
import Models.Common

data BlockRepository = BlockRepository
  { getBlockById :: Id -> IO (Maybe ApiBlock),
    getBlockByHash :: Hash -> IO (Maybe ApiBlock)
  }

mkBlockRepository :: Connection -> BlockRepository
mkBlockRepository conn = BlockRepository (retrieveBlockById conn) (retrieveBlockByHash conn)

retrieveBlockById :: Connection -> Id -> IO (Maybe ApiBlock)
retrieveBlockById conn (Id value) = do
  [Only block] <- query conn "SELECT id, tx_count FROM block WHERE id = ?" $ (Only value)
  return block

retrieveBlockByHash :: Connection -> Hash -> IO (Maybe ApiBlock)
retrieveBlockByHash conn (Hash hash) = do
  [Only block] <- query conn "SELECT id, tx_count FROM block WHERE hash = ?" $ (Only hash)
  return block