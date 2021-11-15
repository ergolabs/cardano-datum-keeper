{-# LANGUAGE RecordWildCards #-}

module Wirings.WiringApp where

import Database.PostgreSQL.Simple
import Http.Server
import Network.Wai.Handler.Warp  (run)
import Data.Aeson                (encode)
import Plutus.V1.Ledger.Scripts  (Datum (..))
import Control.Monad.IO.Class    (MonadIO, liftIO)
import Control.Monad.IO.Unlift
import Repositories.DatumRepository
import Servant.API
import Servant.Server
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
