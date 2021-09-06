{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE UndecidableInstances #-}

module Models.Common where

import Data.Aeson
import Data.Swagger
import Database.PostgreSQL.Simple.FromField (FromField (..))
import Database.PostgreSQL.Simple.FromRow (FromRow (..), field)
import GHC.Generics
import Servant (FromHttpApiData)

newtype Id = Id Int deriving (Generic, Show, FromHttpApiData, FromField)

newtype Address = Address String

instance ToParamSchema Id

instance ToSchema Id

instance FromRow Id where
  fromRow = Id <$> field

instance ToJSON Id

newtype Hash = Hash String
