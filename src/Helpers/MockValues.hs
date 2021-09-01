--Only for tests

module Helpers.MockValues where

import Dex.Models
import Plutus.V1.Ledger.TxId (TxId(..))
import Plutus.V1.Ledger.Value
import Plutus.V1.Ledger.Address    (Address (..))
import qualified PlutusTx.Builtins  as Builtins
import Plutus.V1.Ledger.Credential
import qualified PlutusTx.AssocMap  as Map
import           Plutus.V1.Ledger.Crypto     (PubKeyHash(..))
import qualified PlutusTx
import           Ledger.Scripts            (Datum (..))
import Dex.Contract.Models

mockFullTxOut :: FullTxOut
mockFullTxOut = FullTxOut {
  outGId = GId 10,
  refId = TxId Builtins.emptyByteString,
  refIdx = 10,
  txOutAddress = mockAddress,
  txOutValue = Value Map.empty,
  fullTxOutDatum = Datum $ PlutusTx.toData mockErgoDexPool
}

mockAddress :: Address
mockAddress = Address {
    addressCredential = PubKeyCredential $ PubKeyHash Builtins.emptyByteString,
    addressStakingCredential = Nothing
}

mockErgoDexPool :: ErgoDexPool
mockErgoDexPool = ErgoDexPool 10 mockAssetClass mockAssetClass mockAssetClass

mockAssetClass :: AssetClass
mockAssetClass = AssetClass (mockCurrencySymbol, mockTokenName)

mockCurrencySymbol :: CurrencySymbol
mockCurrencySymbol = CurrencySymbol Builtins.emptyByteString

mockTokenName :: TokenName
mockTokenName = TokenName Builtins.emptyByteString