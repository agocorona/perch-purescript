module Data.Foreign.Class
  ( IsForeign
  
  , read
  , readJSON
  , readWith
  , readProp
  ) where
      
import Data.Array (range, zipWith, length)
import Data.Foreign
import Data.Foreign.Index
import Data.Foreign.Null
import Data.Foreign.Undefined
import Data.Foreign.NullOrUndefined
import Data.Traversable (sequence)
import Data.Either

class IsForeign a where
  read :: Foreign -> F a
  
instance stringIsForeign :: IsForeign String where
  read = readString
  
instance booleanIsForeign :: IsForeign Boolean where
  read = readBoolean
  
instance numberIsForeign :: IsForeign Number where
  read = readNumber
  
instance arrayIsForeign :: (IsForeign a) => IsForeign [a] where
  read value = readArray value >>= readElements
    where
    readElements :: forall a. (IsForeign a) => [Foreign] -> F [a]
    readElements arr = sequence (zipWith readElement (range 0 (length arr)) arr)

    readElement :: forall a. (IsForeign a) => Number -> Foreign -> F [a]
    readElement i value = readWith (ErrorAtIndex i) value
  
instance nullIsForeign :: (IsForeign a) => IsForeign (Null a) where
  read = readNull read
  
instance undefinedIsForeign :: (IsForeign a) => IsForeign (Undefined a) where
  read = readUndefined read
  
instance nullOrUndefinedIsForeign :: (IsForeign a) => IsForeign (NullOrUndefined a) where
  read = readNullOrUndefined read
  
readJSON :: forall a. (IsForeign a) => String -> F a
readJSON json = parseJSON json >>= read

readWith :: forall a e. (IsForeign a) => (ForeignError -> e) -> Foreign -> Either e a
readWith f value = either (Left <<< f) Right (read value)

readProp :: forall a i. (IsForeign a, Index i) => i -> Foreign -> F a
readProp prop value = value ! prop >>= readWith (errorAt prop)
