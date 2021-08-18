module Wirings.WiringApp where

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

-- draft

mkHttpApplication :: BlocksResolver -> TransactionResolver -> WalletResolver -> Application
mkHttpApplication bR tR wR = serve apiProxy (mkApiServer bR tR wR)

initRepositories :: IO (BlockRepository, TransactionRepository, WalletRepository)
initRepositories = pure ( mkBlockRepository, mkTransactionRepository, mkWalletRepository )

initServices :: BlockRepository -> TransactionRepository -> WalletRepository -> IO (BlocksResolver, TransactionResolver, WalletResolver)
initServices bRepo tRepo wRepo = pure (mkBlockResolver bRepo, mkTransactionResolver tRepo, mkWalletResolver wRepo)

initApp :: IO ()
initApp = do
  (bRepo, txRepo, wRepo) <- initRepositories
  (bResolver, txResolver, wResolver) <- initServices bRepo txRepo wRepo
  let app = mkHttpApplication bResolver txResolver wResolver
  run 8012 app
