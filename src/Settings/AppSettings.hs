{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}

module Settings.AppSettings where

import Dhall
import GHC.Generics

data AppSettings = AppSettings
  { psqSettings :: PostgresSettings,
    httpSettings :: HttpSettings
  }
  deriving (Generic, Show)

instance FromDhall AppSettings

data PostgresSettings = PostgresSettings
  { getHost :: String,
    getPort :: Int,
    getUser :: String,
    getPass :: String
  }
  deriving (Generic, Show)

instance FromDhall PostgresSettings

data HttpSettings = HttpSettings
  { getHost :: String,
    getPort :: Int
  }
  deriving (Generic, Show)

instance FromDhall HttpSettings

data SettingsReader = SettingsReader
  { getCfg :: IO AppSettings
  }

mkSettingsReader :: SettingsReader
mkSettingsReader = SettingsReader {
	getCfg = input auto "./config.dhall"
}
