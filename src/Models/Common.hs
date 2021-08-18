{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Models.Common where

import Data.Aeson
import GHC.Generics
import Servant (FromHttpApiData)

newtype Id = Id Integer deriving (Generic, Show, FromHttpApiData) 

instance ToJSON Id

newtype Hash = Hash String
