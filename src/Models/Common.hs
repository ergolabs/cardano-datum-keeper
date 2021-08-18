{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE UndecidableInstances #-}

module Models.Common where

import Data.Aeson
import Database.PostgreSQL.Simple.FromRow (FromRow (..), field)
import GHC.Generics
import Servant (FromHttpApiData)
import Database.PostgreSQL.Simple.FromField (FromField(..))

newtype Id = Id Integer deriving (Generic, Show, FromHttpApiData, FromField)

instance FromRow Id where
  fromRow = Id <$> field

instance ToJSON Id

newtype Hash = Hash String
