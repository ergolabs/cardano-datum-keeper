{-# LANGUAGE RecordWildCards #-}

module Wirings.WiringApp where

import Database.PostgreSQL.Simple
import Http.V1.Routes
import Network.Wai.Handler.Warp (run)
import Data.Aeson (encode)
import Plutus.V1.Ledger.Scripts  (Datum (..))
import Repositories.DatumRepository
import Servant.API
import Servant.Server
import Services.DatumService
import Settings.AppSettings

-- draft

mkConnection :: PostgresSettings -> IO Connection
mkConnection PostgresSettings {..} = do
  let connectInfo =
        ConnectInfo
          { connectHost = getHost,
            connectPort = getPort,
            connectDatabase = getDatabase,
            connectUser = getUser,
            connectPassword = getPass
          }
  connect connectInfo

mkHttpApplication :: DatumService -> Application
mkHttpApplication datumS = serve apiProxy (mkApiServer datumS)

initRepositories :: Connection -> IO DatumRepository
initRepositories conn = pure (mkDatumRepository conn)

initServices :: DatumRepository -> IO DatumService
initServices datumRepo = pure (mkDatumService datumRepo)

initApp :: AppSettings -> IO ()
initApp AppSettings {..}= do
  connection <- mkConnection psgSettings
  datumRepo <- initRepositories connection
  datumService <- initServices datumRepo
  let app = mkHttpApplication datumService
  run 8012 app
