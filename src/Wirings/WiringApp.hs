{-# LANGUAGE RecordWildCards #-}

module Wirings.WiringApp where

import Database.PostgreSQL.Simple
import Http.Server
import Control.Monad.IO.Unlift
import Repositories.DatumRepository
import Services.DatumService
import Settings.AppSettings

mkConnection :: (MonadIO f) => PostgresSettings -> f Connection
mkConnection PostgresSettings {..} = do
  let connectInfo =
        ConnectInfo
          { connectHost = getHost,
            connectPort = getPort,
            connectDatabase = getDatabase,
            connectUser = getUser,
            connectPassword = getPass
          }
  liftIO $ connect connectInfo

initApp :: (MonadIO f) => AppSettings -> UnliftIO f -> f ()
initApp AppSettings{..} ui = do
  connection <- mkConnection psgSettings
  let
    datumRepo = mkDatumRepository connection
    datumService = mkDatumService datumRepo
  runHttpServer httpSettings datumService ui
