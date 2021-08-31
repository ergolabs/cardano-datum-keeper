module Repositories.ProxyRepository (ProxyRepository(..)) where
  
import Dex.Models
import Database.PostgreSQL.Simple
  
data ProxyRepository = ProxyRepository { getProxyTxOuts :: IO [FullTxOut] }

mkProxyRepository :: Connection -> ProxyRepository
mkProxyRepository _ = ProxyRepository getProxyTxOuts' 

getProxyTxOuts' :: IO [FullTxOut]
getProxyTxOuts' = pure []