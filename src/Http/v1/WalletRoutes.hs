module WalletRoutes where

import Prelude ()

import Servant.API
  
type UserAPI1 = "users" :> Get '[JSON] [User]