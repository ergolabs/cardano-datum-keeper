{-# LANGUAGE RecordWildCards #-}

module Wirings.WiringApp where

import Database.PostgreSQL.Simple
import Http.V1.Routes
import Network.Wai.Handler.Warp (run)
import Repositories.BlockRepository
import Repositories.TransactionRepository
import Repositories.WalletRepository
import Repositories.PoolRepository
import Repositories.ProxyRepository
import Servant.API
import Servant.Server
import Services.BlocksResolver
import Services.TransactionResolver
import Services.WalletResolver
import Services.PoolResolver
import Services.ProxyResolver
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
initRepositories conn = pure (mkBlockRepository conn, mkTransactionRepository conn, mkWalletRepository conn, mkPoolRepository conn, mkProxyRepository conn)

initServices :: BlockRepository -> TransactionRepository -> WalletRepository -> PoolRepository -> ProxyRepository -> IO (BlocksResolver, TransactionResolver, WalletResolver, PoolResolver, ProxyResolver)
initServices bRepo tRepo wRepo poolRepo proxyRepo = pure (mkBlockResolver bRepo, mkTransactionResolver tRepo, mkWalletResolver wRepo, mkPoolResolver poolRepo, mkProxyResolver proxyRepo)

initApp :: AppSettings -> IO ()
initApp AppSettings {..}= do
  connection <- mkConnection psgSettings
  (bRepo, txRepo, wRepo, poolRepo, proxyRepo) <- initRepositories connection
  (bResolver, txResolver, wResolver, poolResolver, proxyResolver) <- initServices bRepo txRepo wRepo poolRepo proxyRepo
  let app = mkHttpApplication bResolver txResolver wResolver poolResolver proxyResolver
  run 8012 app
