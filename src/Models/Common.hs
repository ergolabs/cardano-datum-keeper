{-# LANGUAGE DeriveGeneric #-}

module Models.Common where

import Data.Aeson
import GHC.Generics

newtype Id = Id Integer deriving (Generic, Show)

instance ToJSON Id

newtype Hash = Hash String
