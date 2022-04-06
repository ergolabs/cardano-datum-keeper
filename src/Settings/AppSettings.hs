{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}

module Settings.AppSettings where

import Data.Maybe as Maybe
import Data.Text  as T

import Dhall
import Data.Word                (Word16)
import Control.Monad.IO.Class   (MonadIO, liftIO)

data AppSettings = AppSettings
  { psgSettings :: PostgresSettings,
    httpSettings :: HttpSettings
  }
  deriving (Generic, Show)

instance FromDhall AppSettings

data PostgresSettings = PostgresSettings
  { getHost :: String,
    getPort :: Word16,
    getDatabase :: String,
    getUser :: String,
    getPass :: String
  }
  deriving (Generic, Show)

instance FromDhall PostgresSettings

data HttpSettings = HttpSettings
  { getHost :: String,
    getPort :: Natural
  }
  deriving (Generic, Show)

instance FromDhall HttpSettings

loadSetting :: MonadIO f => Maybe String -> f AppSettings
loadSetting maybePath = liftIO $ input auto path
  where path = T.pack $ fromMaybe "./configs/config.dhall" maybePath
