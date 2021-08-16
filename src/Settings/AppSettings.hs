{-# LANGUAGE DuplicateRecordFields #-}

module Settings.AppSettings where

data AppSettings = AppSettings
  { psqSettings :: PostgresSettings,
    httpSettings :: HttpSettings
  }

data PostgresSettings = PostgresSettings
  { getHost :: String,
    getPort :: Int,
    getUser :: String,
    getPass :: String
  }

data HttpSettings = HttpSettings
  { getHost :: String,
    getPort :: Int
  }
