{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}

module Settings.AppSettings where

import Dhall
import GHC.Generics
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

data SettingsReader f = SettingsReader
  { getCfg :: f AppSettings
  }

mkSettingsReader :: (MonadIO f) => SettingsReader f
mkSettingsReader = SettingsReader $ liftIO $ input auto "./configs/config.dhall"
