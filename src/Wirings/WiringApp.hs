{-# LANGUAGE RecordWildCards #-}

module Wirings.WiringApp where

import Database.PostgreSQL.Simple
import Http.V1.Routes
import Network.Wai.Handler.Warp (run)
import Repositories.BlockRepository
import Repositories.TransactionRepository
import Repositories.WalletRepository
import Servant.API
import Servant.Server
import Services.BlocksResolver
import Services.TransactionResolver
import Services.WalletResolver
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

mkHttpApplication :: BlocksResolver -> TransactionResolver -> WalletResolver -> PoolResolver -> ProxyResolver -> Application
mkHttpApplication bR tR wR poolR proxyR = serve apiProxy (mkApiServer bR tR wR poolR proxyR)

initRepositories :: Connection -> IO (BlockRepository, TransactionRepository, WalletRepository, PoolRepository, ProxyRepository)
initRepositories conn = pure (mkBlockRepository conn, mkTransactionRepository conn, mkWalletRepository conn)

initServices :: BlockRepository -> TransactionRepository -> WalletRepository -> PoolRepository -> ProxyRepository -> IO (BlocksResolver, TransactionResolver, WalletResolver, PoolResolver, ProxyResolver)
initServices bRepo tRepo wRepo = pure (mkBlockResolver bRepo, mkTransactionResolver tRepo, mkWalletResolver wRepo)

initApp :: AppSettings -> IO ()
initApp AppSettings {..}= do
  connection <- mkConnection psgSettings
  (bRepo, txRepo, wRepo) <- initRepositories connection
  (bResolver, txResolver, wResolver) <- initServices bRepo txRepo wRepo
  let app = mkHttpApplication bResolver txResolver wResolver
  run 8012 app
