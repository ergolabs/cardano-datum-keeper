{-# LANGUAGE RecordWildCards #-}

module Wirings.WiringApp where

import Database.PostgreSQL.Simple
import Http.V1.Routes
import Network.Wai.Handler.Warp (run)
import qualified PlutusTx                              as PlutusTx
import Data.Aeson (encode)
import Plutus.V1.Ledger.Scripts  (Datum (..))
import Repositories.BlockRepository
import Repositories.TransactionRepository
import Repositories.WalletRepository
import Repositories.PoolRepository
import Repositories.ProxyRepository
import Repositories.DatumRepository
import Helpers.MockValues
import Servant.API
import Servant.Server
import Services.BlocksResolver
import Services.TransactionResolver
import Services.WalletResolver
import Services.DatumService
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

mkHttpApplication :: BlocksResolver -> TransactionResolver -> WalletResolver -> PoolResolver -> ProxyResolver -> DatumService -> Application
mkHttpApplication bR tR wR poolR proxyR datumS = serve apiProxy (mkApiServer bR tR wR poolR proxyR datumS)

initRepositories :: Connection -> IO (BlockRepository, TransactionRepository, WalletRepository, PoolRepository, ProxyRepository, DatumRepository)
initRepositories conn = pure (mkBlockRepository conn,mkTransactionRepository conn,mkWalletRepository conn,mkPoolRepository conn,mkProxyRepository conn,mkDatumRepository conn)

initServices :: BlockRepository -> TransactionRepository -> WalletRepository -> PoolRepository -> ProxyRepository -> DatumRepository -> IO (BlocksResolver, TransactionResolver, WalletResolver, PoolResolver, ProxyResolver, DatumService)
initServices bRepo tRepo wRepo poolRepo proxyRepo datumRepo = pure (mkBlockResolver bRepo, mkTransactionResolver tRepo, mkWalletResolver wRepo, mkPoolResolver poolRepo, mkProxyResolver proxyRepo, mkDatumService datumRepo)

initApp :: AppSettings -> IO ()
initApp AppSettings {..}= do
  connection <- mkConnection psgSettings
  let dat = Datum $ PlutusTx.toData mockErgoDexPool
  test <- print $ encode dat
  (bRepo, txRepo, wRepo, poolRepo, proxyRepo, datumRepo) <- initRepositories connection
  (bResolver, txResolver, wResolver, poolResolver, proxyResolver, datumService) <- initServices bRepo txRepo wRepo poolRepo proxyRepo datumRepo
  let app = mkHttpApplication bResolver txResolver wResolver poolResolver proxyResolver datumService
  run 8012 app
