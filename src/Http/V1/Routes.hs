{-# LANGUAGE TypeOperators #-}

module Http.V1.Routes where

import Http.V1.BlockRoutes
import Http.V1.TransactionRoutes
import Http.V1.WalletRoutes
import Servant.API
import Servant.Server
import Servant
import Services.BlocksResolver
import Services.TransactionResolver
import Services.WalletResolver

type Api = BlockAPI :<|> TransactionAPI :<|> WalletAPI

apiProxy :: Proxy Api
apiProxy = Proxy

mkApiServer :: BlocksResolver -> TransactionResolver -> WalletResolver -> Server Api
mkApiServer blockR txR walletR = mkBlockApiServer blockR :<|> mkTransactionAPIServer txR :<|> mkWalletApiServer walletR
