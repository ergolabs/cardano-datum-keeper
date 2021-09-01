module Repositories.ProxyRepository (ProxyRepository(..), mkProxyRepository) where
  
import Dex.Models
import Database.PostgreSQL.Simple
  
data ProxyRepository = ProxyRepository { getProxyTxOuts :: IO [FullTxOut] }

mkProxyRepository :: Connection -> ProxyRepository
mkProxyRepository conn = ProxyRepository getProxyTxOuts' 

getPoolTxOuts' :: Connection -> IO [FullTxOut]
getPoolTxOuts' conn = do
  rawOuts <- query_ conn "SELECT tx.hash, index, address_raw, value, data_hash FROM tx_out INNER JOIN tx ON tx_out.tx_id = tx.id WHERE data_hash is not NULL" :: IO [(Builtins.ByteString, Int, Builtins.ByteString, Scientific, Builtins.ByteString)]
  forM rawOuts $ \out -> do
    let (txId, index, addrRaw, value, dataHash) = out
    return FullTxOut {
      outGId = GId 10,
      refId = TxId $ txId,
      refIdx = index,
      txOutAddress = scriptHashAddress $ ValidatorHash addrRaw,
      txOutValue = Value Map.empty,
      fullTxOutDatum = Datum $ PlutusTx.toData mockErgoDexPool
    }