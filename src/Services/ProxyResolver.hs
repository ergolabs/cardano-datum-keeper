module Services.ProxyResolver where

import Dex.Models
import Repositories.ProxyRepository

data ProxyResolver = ProxyResolver { getProxyTxOuts :: IO [FullTxOut] }

mkProxyResolver :: ProxyRepository -> ProxyResolver
mkProxyResolver repo = ProxyResolver (getProxyTxOuts' repo)

getProxyTxOuts' :: ProxyRepository -> IO [FullTxOut]
getProxyTxOuts' _ = pure ([] :: [FullTxOut])

