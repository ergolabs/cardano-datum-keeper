{-#LANGUAGE OverloadedStrings #-}

module Repositories.ProxyRepository (ProxyRepository(..), mkProxyRepository) where
  
import Dex.Models
import Control.Monad
import Codec.Serialise
import Database.PostgreSQL.Simple
import Data.Scientific
import qualified Data.ByteString.Lazy          as BL
import qualified Data.ByteString               as B
import Plutus.V1.Ledger.Value
import qualified Data.ByteString.Char8    as BS
import Data.Binary (encode, Word8)
import qualified PlutusTx
import Plutus.V1.Ledger.TxId (TxId(..))
import Plutus.V1.Ledger.Address
import qualified PlutusTx.Builtins  as Builtins
import Plutus.V1.Ledger.Credential
import qualified PlutusTx.AssocMap  as Map
import           Plutus.V1.Ledger.Crypto     (PubKeyHash(..))
import           Ledger.Scripts            (Datum (..), ValidatorHash(..))
import Helpers.MockValues
  
data ProxyRepository = ProxyRepository { getProxyTxOuts :: IO [FullTxOut] }

mkProxyRepository :: Connection -> ProxyRepository
mkProxyRepository conn = ProxyRepository (getProxyTxOuts' conn)

getProxyTxOuts' :: Connection -> IO [FullTxOut]
getProxyTxOuts' conn = do
  rawOuts <- query_ conn "SELECT tx.hash, index, address_raw, value, data_hash FROM tx_out INNER JOIN tx ON tx_out.tx_id = tx.id WHERE data_hash is not NULL" :: IO [(Builtins.ByteString, Integer, Builtins.ByteString, Scientific, Builtins.ByteString)]
  forM rawOuts $ \out -> do
    let (txId, index, addrRaw, value, dataHash) = out
    return FullTxOut {
      outGId = GId 10,
      refId = TxId txId,
      refIdx = index,
      txOutAddress = scriptHashAddress $ ValidatorHash addrRaw,
      txOutValue = Value Map.empty,
      fullTxOutDatum = Datum $ PlutusTx.toData mockErgoDexPool
    }